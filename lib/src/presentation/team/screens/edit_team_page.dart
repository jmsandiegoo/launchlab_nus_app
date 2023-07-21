import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:launchlab/src/data/common/common_repository.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/date_picker.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/dropwdown_search_field.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/picture_upload_picker.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/team/cubits/edit_create_team_cubit.dart';
import 'package:launchlab/src/presentation/team/widgets/commitment_button.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../config/app_theme.dart';

class EditTeamPage extends StatelessWidget {
  final String teamId;

  const EditTeamPage({super.key, required this.teamId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditCreateTeamCubit(
          CommonRepository(Supabase.instance), TeamRepository()),
      child: EditTeamContent(teamId: teamId),
    );
  }
}

class EditTeamContent extends StatefulWidget {
  final String teamId;

  const EditTeamContent({super.key, required this.teamId});

  @override
  State<EditTeamContent> createState() => _EditTeamContentState();
}

class _EditTeamContentState extends State<EditTeamContent> {
  late EditCreateTeamCubit editCreateTeamCubit;

  _EditTeamContentState();
  final _teamNameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _startDateFocusNode = FocusNode();
  final _endDateFocusNode = FocusNode();
  final _categories = [
    "School",
    "Personal",
    "Competition",
    "Startup / Company",
    "Volunteer Work",
    "Others"
  ];
  final _maxMemberFocusNode = FocusNode();

  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _maxMemberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    editCreateTeamCubit = BlocProvider.of<EditCreateTeamCubit>(context);
    editCreateTeamCubit.getData(widget.teamId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCreateTeamCubit, EditCreateTeamState>(
        builder: (context, state) {
      return editCreateTeamCubit.state.status == EditCreateStatus.success
          ? Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: blackColor),
                  onPressed: () => navigatePop(context),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  headerText("Edit Team"),
                                  bodyText("Need Some Changes?"),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: PictureUploadPickerWidget(
                                      onPictureUploadChangedHandler: (image) =>
                                          editCreateTeamCubit
                                              .onPictureUploadChanged(image),
                                      image: editCreateTeamCubit
                                          .state.pictureUploadInput.value,
                                      isTeam: true,
                                      imageURL: editCreateTeamCubit
                                          .state.avatarURL
                                          .toString(),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                  height: 100,
                                  child: SvgPicture.asset(
                                      'assets/images/create_team.svg'))
                            ]),
                        const SizedBox(height: 20),
                        TextFieldWidget(
                          focusNode: _teamNameFocusNode,
                          controller: _teamNameController,
                          onChangedHandler: (val) {
                            editCreateTeamCubit.onTeamNameChanged(val);
                          },
                          label: "Team Name",
                          hint: "Team Name",
                          value: editCreateTeamCubit.state.teamNameInput.value,
                          errorText: editCreateTeamCubit
                              .state.teamNameInput.displayError
                              ?.text(),
                        ),
                        TextFieldWidget(
                          focusNode: _descriptionFocusNode,
                          controller: _descriptionController,
                          onChangedHandler: (val) {
                            editCreateTeamCubit.onDescriptionChanged(val);
                          },
                          label: "Description",
                          hint: "\n\n\n\nDescription",
                          value:
                              editCreateTeamCubit.state.descriptionInput.value,
                          errorText: editCreateTeamCubit
                              .state.descriptionInput.displayError
                              ?.text(),
                          minLines: 10,
                          maxLines: 10,
                        ),
                        Row(children: [
                          Expanded(
                            child: DatePickerWidget(
                              controller: _startDateController,
                              focusNode: _startDateFocusNode,
                              label: "Start Date",
                              hint: '',
                              onChangedHandler: (value) =>
                                  editCreateTeamCubit.onStartDateChanged(value),
                              initialDate: state.startDateInput.value,
                              lastDate: DateTime(2050),

                              //errorText: state.startDateInput.displayError?.text(),
                            ),
                          ),
                          Container(
                            height: 30,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: const Text("—"),
                          ),
                          Expanded(
                            child: state.isChecked.value
                                ? DatePickerWidget(
                                    isEnabled: false,
                                    controller: _endDateController,
                                    focusNode: _endDateFocusNode,
                                    label: "End Date",
                                    hint: '',
                                    onChangedHandler: (value) =>
                                        editCreateTeamCubit
                                            .onEndDateChanged(value),
                                    initialDate: state.endDateInput.value,
                                    lastDate: DateTime(2100),
                                    //errorText:state.endDateInput.displayError?.text(),
                                  )
                                : DatePickerWidget(
                                    isEnabled:
                                        state.startDateInput.value != null,
                                    controller: _endDateController,
                                    focusNode: _endDateFocusNode,
                                    label: "End Date",
                                    hint: '',
                                    onChangedHandler: (value) =>
                                        editCreateTeamCubit
                                            .onEndDateChanged(value),
                                    initialDate: state.endDateInput.value,
                                    lastDate: DateTime(2100),
                                    //errorText:state.endDateInput.displayError?.text(),
                                  ),
                          ),
                        ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              checkBox(
                                "No End Date",
                                state.isChecked.value,
                                false,
                                (value) => editCreateTeamCubit
                                    .onIsCheckedChanged(value!),
                              )
                            ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Category",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: blackColor)),
                              const SizedBox(height: 5),
                              SizedBox(
                                height: 50.0,
                                child: DropdownButtonFormField(
                                  isDense: true,
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 20, 10, 14),
                                    fillColor: whiteColor,
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: lightGreyColor, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: lightGreyColor, width: 1),
                                    ),
                                  ),
                                  isExpanded: true,
                                  value:
                                      editCreateTeamCubit.state.categoryInput,
                                  style: const TextStyle(
                                      color: blackColor, fontSize: 15),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: _categories.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    editCreateTeamCubit
                                        .onCategoryChanged(newValue!);
                                  },
                                ),
                              ),
                            ]),
                        const SizedBox(height: 20),
                        subHeaderText("Commitment Level", size: 15.0),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CommitmentButton(
                                  text: "    Low    ",
                                  newLevel: 'Low',
                                  cubit: editCreateTeamCubit),
                              CommitmentButton(
                                  text: "  Medium  ",
                                  newLevel: 'Medium',
                                  cubit: editCreateTeamCubit),
                              CommitmentButton(
                                  text: "    High    ",
                                  newLevel: 'High',
                                  cubit: editCreateTeamCubit),
                            ]),
                        const SizedBox(height: 20),
                        TextFieldWidget(
                          focusNode: _maxMemberFocusNode,
                          controller: _maxMemberController,
                          onChangedHandler: (val) {
                            editCreateTeamCubit.onMaxMemberChanged(val);
                          },
                          label: 'Total Member',
                          hint: 'Input a number',
                          value: editCreateTeamCubit.state.maxMemberInput.value,
                          keyboard: TextInputType.number,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          errorText: editCreateTeamCubit
                              .state.maxMemberInput.displayError
                              ?.text(),
                        ),
                        const Text("Interest Areas",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: blackColor)),
                        const SizedBox(height: 5),
                        DropdownSearchFieldMultiWidget<SkillEntity>(
                          focusNode: FocusNode(),
                          label: "",
                          getItems: (String filter) async {
                            await editCreateTeamCubit
                                .handleGetSkillsInterests(filter);
                            return editCreateTeamCubit
                                .state.skillInterestOptions;
                          },
                          selectedItems:
                              editCreateTeamCubit.state.interestInput.value,
                          isChipsOutside: true,
                          isFilterOnline: true,
                          onChangedHandler: (values) {
                            editCreateTeamCubit.onInterestChanged(values);
                          },
                          compareFnHandler: (p0, p1) => p0.emsiId == p1.emsiId,
                        ),
                        const SizedBox(height: 20),
                        Center(
                            child: ElevatedButton(
                                onPressed: () {
                                  editCreateTeamCubit.finish()
                                      ? editCreateTeamCubit
                                          .updateTeamData(
                                              teamId: widget.teamId,
                                              teamName:
                                                  _teamNameController.text,
                                              description:
                                                  _descriptionController.text,
                                              startDate:
                                                  _startDateController.text,
                                              endDate: _endDateController.text,
                                              category: state.categoryInput,
                                              commitment: state.commitmentInput,
                                              maxMember:
                                                  _maxMemberController.text,
                                              interest:
                                                  state.interestInput.value,
                                              avatar: state
                                                  .pictureUploadInput.value)
                                          .then((_) {
                                          navigatePopWithData(context, true,
                                              ActionTypes.update);
                                        })
                                      : debugPrint("Not Validated");
                                },
                                child: bodyText("   Update   "))),
                        const SizedBox(height: 50),
                      ]),
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator());
    });
  }
}
