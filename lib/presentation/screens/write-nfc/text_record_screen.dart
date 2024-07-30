import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nfc_app/constants/app_colors.dart';
import 'package:nfc_app/constants/app_spacing.dart';
import 'package:nfc_app/notifier/nfc_notifier.dart';
import 'package:nfc_app/presentation/screens/translate/translate_screen.dart';
import 'package:nfc_app/presentation/widgets/app_bottom_sheet.dart';
import 'package:nfc_app/presentation/widgets/app_buttons.dart';
import 'package:nfc_app/presentation/widgets/circle_progress_indicator.dart';
import 'package:provider/provider.dart';

class TextRecordScreen extends StatefulWidget {
  const TextRecordScreen({super.key});

  @override
  State<TextRecordScreen> createState() => _TextRecordScreenState();
}

class _TextRecordScreenState extends State<TextRecordScreen> {
  final controller = TextEditingController();

  writeToNfc() {
    Provider.of<NFCNotifier>(context, listen: false).startNFCOperation(
        nfcOperation: NFCOperation.write,
        context: context,
        content: controller.text);
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: AppBottomsheet(
              hasInactiveButton: true,
              inactiveButtonText: "Continue",
              inactiveButtonOnTap: () {},
              message:
                  "Please place the back of your device near the tag receiver to read tag.",
              title: "Ready to Scan",
              centerContent:
                  SvgPicture.asset('assets/icons/svg/ready_to_scan.svg'),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NFCNotifier(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor2,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: SvgPicture.asset(
              'assets/arrow_left.svg',
              fit: BoxFit.scaleDown,
            ),
          ),
          title: Text(
            'Text Record',
            style: GoogleFonts.inter(
              color: AppColors.primaryTextColor,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Padding(
          padding: AllPadding.padding16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    'Enter Text Record',
                    style: GoogleFonts.inter(
                      color: AppColors.primaryTextColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const YGap(value: 16.0),
                  SizedBox(
                    height: 121.0,
                    child: TextField(
                      controller: controller,
                      maxLines: 4, // Allow up to 3 lines of text
                      // minLines: 4, // Ensure at least one line is visible
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        labelText: 'Enter text here',
                        // labelStyle: ,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        constraints: BoxConstraints(
                          maxHeight: 121,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const YGap(value: 16.0),
              PrimaryButton(
                  onTap: () {
                    writeToNfc();
                  },
                  text: 'Add'),
              Consumer<NFCNotifier>(builder: (context, provider, _) {
                if (provider.isProcessing) {
                  // return const CircularProgressIndicator();
                  showModalBottomSheet(
                      isDismissible: false,
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: const AppBottomsheet(
                            message: "Make sure your device is well placed.",
                            title: "Scanning...",
                            centerContent: ProgressIndicatorWithText(
                              progress: 0.75,
                            ),
                          ),
                        );
                      });
                }
                if (provider.message.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pop(context);
                    showModalBottomSheet(
                        isDismissible: false,
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: AppBottomsheet(
                              hasPrimaryButton: true,
                              primaryButtonText: "Continue",
                              primaryButtonOnTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (txt) => TranslateScreen(
                                            message: provider.message)));
                              },
                              message: "Make sure your device is well placed.",
                              title: "Scan Successful!",
                              centerContent: const ProgressIndicatorWithText(
                                progress: 1.0,
                              ),
                            ),
                          );
                        });
                  });
                }
                return const SizedBox();
              }),
            ],
          ),
        ),
      ),
    );
  }
}