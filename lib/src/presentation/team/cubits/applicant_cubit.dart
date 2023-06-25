import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApplicantState extends Equatable {
  @override
  List<Object?> get props => [];

  const ApplicantState();
}

class ApplicantCubit extends Cubit<ApplicantState> {
  ApplicantCubit() : super(const ApplicantState());
  final supabase = Supabase.instance.client;

  getData(applicationID) async {
    var applicantUserData = await supabase
        .from('users')
        .select('*, team_applicants!inner(id), degree_programmes(name)')
        .eq('team_applicants.id', applicationID);

    var avatarURL = applicantUserData[0]['avatar'] == null
        ? ''
        : await supabase.storage
            .from('user_avatar_bucket')
            .createSignedUrl('${applicantUserData[0]['avatar']}', 60);

    applicantUserData[0]['avatar_url'] = avatarURL;

    var teamData = await supabase
        .from('teams')
        .select('current_members, max_members, team_applicants!inner(id)')
        .eq('team_applicants.id', applicationID);

    var experienceData = await supabase
        .from('experiences')
        .select()
        .eq('user_id', applicantUserData[0]['id'])
        .order('start_date');

    var accomplishmentData = await supabase
        .from('accomplishments')
        .select()
        .eq('user_id', applicantUserData[0]['id'])
        .order('start_date');

    return [applicantUserData, teamData, experienceData, accomplishmentData];
  }

  acceptApplicant({applicationID, currentMember}) async {
    var applicationData =
        await supabase.from('team_applicants').select().eq('id', applicationID);

    await supabase.from('team_users').insert({
      'team_id': applicationData[0]['team_id'],
      'user_id': applicationData[0]['user_id'],
      'position': 'Member',
    });

    await supabase.from('teams').update({
      'current_members': currentMember + 1,
    }).eq('id', applicationData[0]['team_id']);

    await supabase.from('team_applicants').delete().eq('id', applicationID);

    debugPrint('Applicant Accepted');
  }

  rejectApplicant({applicationID}) async {
    await supabase.from('team_applicants').delete().eq('id', applicationID);
    debugPrint('Applicant Rejected');
  }
}
