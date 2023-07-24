import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchlab/src/domain/team/responses/get_applicant_data.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/presentation/team/cubits/applicant_cubit.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/failure.dart';
import 'package:mocktail/mocktail.dart';

import 'package:launchlab/src/data/team/team_repository.dart';

class MockTeamRepository extends Mock implements TeamRepository {}

void main() {
  late MockTeamRepository mockTeamRepository;
  late ApplicantCubit applicantCubit;

  group("Applicant Cubit", () {
    setUp(() async {
      mockTeamRepository = MockTeamRepository();
      applicantCubit = ApplicantCubit(mockTeamRepository);
    });

    final Failure failure = Failure.request();
    const String applicationId = '';
    TeamEntity teamData = TeamEntity('', '', '', 1, 1, DateTime.now(), null, '',
        '', const [], null, '', true, true, const []);
    GetApplicantData applicantData =
        GetApplicantData(teamData, const [], const []);

    blocTest<ApplicantCubit, ApplicantState>(
      'emits [applicationTeamData, ApplicantStatus.success] when data is loaded successfully.',
      build: () => applicantCubit,
      setUp: () =>
          when(() => mockTeamRepository.getApplicantData(applicationId))
              .thenAnswer((_) async => applicantData),
      act: (cubit) => cubit.getData(applicationId),
      expect: () => <ApplicantState>[
        ApplicantState(
            applicationTeamData: teamData, status: ApplicantStatus.success)
      ],
      verify: (_) async {
        verify(() => mockTeamRepository.getApplicantData(applicationId))
            .called(1);
      },
    );

    blocTest<ApplicantCubit, ApplicantState>(
      'Emits [ApplicantStatus.error] when failure is caught.',
      setUp: () =>
          when(() => mockTeamRepository.getApplicantData(applicationId))
              .thenThrow(failure),
      build: () => applicantCubit,
      act: (cubit) => cubit.getData(applicationId),
      expect: () => <ApplicantState>[
        ApplicantState(status: ApplicantStatus.error, error: failure),
      ],
      verify: (_) async {
        verify(() => mockTeamRepository.getApplicantData(applicationId))
            .called(1);
      },
    );

    blocTest<ApplicantCubit, ApplicantState>(
      'Emits [ApplicantStatus.loading] when calling loading()',
      build: () => applicantCubit,
      act: (cubit) => cubit.loading(),
      expect: () => [const ApplicantState(status: ApplicantStatus.loading)],
    );

    blocTest<ApplicantCubit, ApplicantState>(
      'Emits [ApplicantStatus.loading, actionTypes.update] when applicant is accepted.',
      build: () => applicantCubit,
      act: (cubit) =>
          cubit.acceptApplicant(applicationID: applicationId, currentMember: 1),
      expect: () => <ApplicantState>[
        const ApplicantState(status: ApplicantStatus.loading),
        const ApplicantState(actionTypes: ActionTypes.update),
      ],
    );

    blocTest<ApplicantCubit, ApplicantState>(
      'Emits [ApplicantStatus.loading, actionTypes.update] when applicant is rejected.',
      build: () => applicantCubit,
      act: (cubit) => cubit.rejectApplicant(applicationID: applicationId),
      expect: () => <ApplicantState>[
        const ApplicantState(status: ApplicantStatus.loading),
        const ApplicantState(actionTypes: ActionTypes.update),
      ],
    );
  });
}
