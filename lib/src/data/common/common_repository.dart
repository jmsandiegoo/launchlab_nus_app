import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:launchlab/src/domain/common/models/category_entity.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';
import 'package:launchlab/src/domain/common/repositories/common_repository_impl.dart';
import 'package:launchlab/src/utils/emsi_token_cache.dart';
import 'package:launchlab/src/utils/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommonRepository implements CommonRepositoryImpl {
  final Supabase _supabase;
  CommonRepository(this._supabase);

  final EmsiTokenCache _emsiTokenCache = EmsiTokenCache();

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final res =
          await _supabase.client.from('categories').select<PostgrestList>('*');
      print("res ${res}");
      List<CategoryEntity> categoryList = [];

      for (int i = 0; i < res.length; i++) {
        categoryList.add(CategoryEntity.fromJson(res[i]));
      }

      return categoryList;
    } on Exception catch (error) {
      print("get Categories error: ${error}");
      throw const Failure.badRequest();
    }
  }

  Future<List<SkillEntity>> getSkillsInterestsFromEmsi(String? filter) async {
    // check current token
    try {
      String? cachedEmsiToken = await _emsiTokenCache.getToken();
      final isTokenInvalid = await _emsiTokenCache.isTokenExpired();

      if (isTokenInvalid) {
        cachedEmsiToken = await getNewEmsiToken();
        await _emsiTokenCache.cacheToken(cachedEmsiToken);
      }

      // fetch emsi skills
      final url =
          Uri.parse('https://emsiservices.com/skills/versions/latest/skills');

      final queryParams = {
        'limit': '20',
      };

      if (filter != null && filter.trim().isNotEmpty) {
        queryParams['q'] = filter;
      }

      final headers = {'Authorization': 'Bearer $cachedEmsiToken'};
      final response = await http.get(url.replace(queryParameters: queryParams),
          headers: headers);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        List<SkillEntity> skillInterestList = [];

        for (int i = 0; i < responseBody['data'].length; i++) {
          skillInterestList
              .add(SkillEntity.fromJsonEmsi(responseBody['data'][i]));
        }

        return skillInterestList;
      } else {
        throw const Failure.badRequest();
      }
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<String> getNewEmsiToken() async {
    final url = Uri.parse('https://auth.emsicloud.com/connect/token');

    final headers = {'content-type': 'application/x-www-form-urlencoded'};
    final body = {
      'client_id': 'j5lbf11nxqf67myv',
      'client_secret': 'aDNqlUyj',
      'grant_type': 'client_credentials',
      'scope': 'emsi_open',
    };

    final response = await http.post(
      url,
      headers: headers,
      body: body,
      encoding: Encoding.getByName('utf-8'),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final accessToken = responseBody['access_token'] as String;

      return accessToken;
    } else {
      throw const Failure.badRequest();
    }
  }
}
