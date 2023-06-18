import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/date_picker.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/dropwdown_search_field.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/team/cubits/edit_create_team_cubit.dart';
import 'package:launchlab/src/utils/helper.dart';
import '../../../config/app_theme.dart';

class EditTeamPage extends StatefulWidget {
  final String teamId;

  const EditTeamPage({super.key, required this.teamId});

  @override
  State<EditTeamPage> createState() => _EditTeamPageState(teamId);
}

class _EditTeamPageState extends State<EditTeamPage> {
  _EditTeamPageState(this.teamId);
  String teamId;
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
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => EditCreateTeamCubit(),
        child: BlocBuilder<EditCreateTeamCubit, EditCreateTeamState>(
            builder: (context, state) {
          final editCreateTeamCubit =
              BlocProvider.of<EditCreateTeamCubit>(context);
          if (_teamNameController.text == '' &&
              _descriptionController.text == '' &&
              _startDateController.text == '' &&
              _endDateController.text == '' &&
              _maxMemberController.text == '') {
            editCreateTeamCubit.getData(teamId).then((data) {
              editCreateTeamCubit.initState(
                teamName: data[0]['team_name'],
                description: data[0]['description'],
                startDate: data[0]['start_date'],
                commitment: data[0]['commitment'],
                category: data[0]['project_category'],
                maxMember: data[0]['max_members'],
              );

              data[0]['end_date'] == null
                  ? editCreateTeamCubit.onIsCheckedChanged(true)
                  : editCreateTeamCubit
                      .onEndDateChanged(DateTime.parse(data[0]['end_date']));
              _teamNameController.text = data[0]['team_name'];
              _descriptionController.text = data[0]['description'];
              _maxMemberController.text = data[0]['max_members'].toString();

              debugPrint("Data Loaded");
            });
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: blackColor),
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
                                bodyText("Need Some Changes?")
                              ],
                            ),
                            SizedBox(
                                height: 150,
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
                        value: editCreateTeamCubit.state.descriptionInput.value,
                        errorText: editCreateTeamCubit
                            .state.descriptionInput.displayError
                            ?.text(),
                        size: 10,
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
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: const Text("\n—"),
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
                                  isEnabled: state.startDateInput.value != null,
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
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        checkBox(
                          "No End Date",
                          state.isChecked.value,
                          false,
                          (value) =>
                              editCreateTeamCubit.onIsCheckedChanged(value!),
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
                                value: editCreateTeamCubit.state.categoryInput,
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
                                  debugPrint(newValue);
                                },
                              ),
                            ),
                          ]),
                      const SizedBox(height: 20),
                      subHeaderText("Commitment Level", size: 15.0),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            commitmentButton(
                                "    Low    ", 'Low', editCreateTeamCubit),
                            commitmentButton(
                                "  Medium  ", 'Medium', editCreateTeamCubit),
                            commitmentButton(
                                "    High    ", 'High', editCreateTeamCubit),
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
                      DropdownSearchFieldMultiWidget(
                        focusNode: FocusNode(),
                        label: "",
                        getItems: (String filter) async =>
                            ["Java", "Android", "Web Dev"],
                        selectedItems:
                            editCreateTeamCubit.state.interestInput.value,
                        isChipsOutside: true,
                        onChangedHandler: (values) =>
                            editCreateTeamCubit.onInterestChanged(values),
                      ),
                      const SizedBox(height: 20),
                      Center(
                          child: ElevatedButton(
                              onPressed: () {
                                print(state.interestInput.value);
                                editCreateTeamCubit.finish()
                                    ? editCreateTeamCubit
                                        .updateTeamData(
                                            teamId: teamId,
                                            teamName: _teamNameController.text,
                                            description:
                                                _descriptionController.text,
                                            startDate:
                                                _startDateController.text,
                                            endDate: _endDateController.text,
                                            category: state.categoryInput,
                                            commitment: state.commitmentInput,
                                            maxMember:
                                                _maxMemberController.text)
                                        .then((val) {
                                        navigatePop(context);
                                      })
                                    : debugPrint("Not Validated");
                              },
                              child: bodyText("   Update   "))),
                      const SizedBox(height: 50),
                    ]),
              ),
            ),
          );
        }));
  }

  Widget commitmentButton(text, newLevel, cubit) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            backgroundColor: cubit.state.commitmentInput == newLevel
                ? blackColor
                : lightGreyColor),
        onPressed: () {
          cubit.onCommitmentChanged(newLevel);
        },
        child: bodyText(text,
            size: 12.0,
            color: cubit.state.commitmentInput == newLevel
                ? whiteColor
                : blackColor));
  }
}
