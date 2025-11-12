import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidybee_fe_app/core/common_services/location.dart';
import 'package:tidybee_fe_app/core/common_widgets/notification_service.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';
import 'package:tidybee_fe_app/features/customer/screens/customer_home/service_detail/address_section.dart';
import 'package:tidybee_fe_app/features/customer/screens/customer_home/service_detail/description_section.dart';
import 'package:tidybee_fe_app/features/customer/screens/customer_home/service_detail/note_section.dart';
import 'package:tidybee_fe_app/features/customer/screens/customer_home/service_detail/working_time_section.dart';
import 'package:tidybee_fe_app/features/customer/services/booking_services.dart';
import 'package:tidybee_fe_app/features/customer/services/validate_booking.dart';

class CustomerServicesDetailScreen extends StatefulWidget {
  final String title;
  final int id;
  final String description;
  final String token;

  const CustomerServicesDetailScreen({
    super.key,
    required this.title,
    required this.id,
    required this.description,
    required this.token,
  });

  @override
  State<CustomerServicesDetailScreen> createState() =>
      _CustomerServicesDetailScreenState();
}

class _CustomerServicesDetailScreenState
    extends State<CustomerServicesDetailScreen> {
  String? _currentAddress;
  // ignore: unused_field
  bool _isLoading = false;

  double? _latitude;
  double? _longitude;
  String? _address;
  String? _city;
  String? _district;
  String? _ward;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  DateTime? _selectedDate;
  String? _note;
  bool? _isRecursion = false;
  DateTime? _recursionDate;

  // Create instance object of BookingServices
  final BookingServices bookingServices = BookingServices();

  @override
  void initState() {
    super.initState();
    _fetchCurrentAddress();
  }

  //Method get current location
  Future<void> _fetchCurrentAddress() async {
    setState(() => _isLoading = true);

    try {
      // Call method getCurrentPosition
      final positionData = await LocationService.getCurrentPosition();
      if (positionData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Vui lòng bật GPS hoặc cấp quyền truy cập"),
          ),
        );
        return;
      } else {
        setState(() {
          _latitude = positionData["latitude"];
          _longitude = positionData["longitude"];
        });
      }

      final position = positionData["position"] as Position;

      // Call method getAddressFromPosition
      final addressData = await LocationService.getAddressFromPosition(
        position,
      );
      setState(() {
        _currentAddress = addressData!["fullAddress"];
        _address = addressData["address"];
        _city = addressData["city"];
        _district = addressData["district"];
        _ward = addressData["ward"];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể lấy vị trí hiện tại')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Method submit booking
  void _submitBooking() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    setState(() {
      _isLoading = true;
    });

    // Validate
    if (!ValidateBooking.validateBooking(
      context,
      latitude: _latitude,
      longitude: _longitude,
      address: _address,
      note: _note,
      startTime: _startTime,
      endTime: _endTime,
    )) {
      setState(() {
        _isLoading = false;
      });

      return;
    }

    // Formatter date time
    final startDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _startTime!.hour,
      _startTime!.minute,
    );
    final endDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _endTime!.hour,
      _endTime!.minute,
    );

    final bookingData = {
      "serviceType": widget.id,
      "title": widget.title,
      "description": widget.description,
      "serviceLocation": {
        "latitude": _latitude,
        "longitude": _longitude,
        "address": _address,
        "city": _city,
        "district": _district ?? "",
        "ward": _ward ?? "",
      },
      "scheduledStartTime": "${startDateTime.toIso8601String()}Z",
      "scheduledEndTime": "${endDateTime.toIso8601String()}Z",
      "customerNotes": _note,
      "isRecurring": _isRecursion,
      "recurringPattern": "week",
      "recurringEndDate": _recursionDate != null
          ? "${_recursionDate!.toIso8601String()}Z"
          : "2030-10-19T20:54:24.952Z",
    };

    print(bookingData);

    try {
      final newBooking = await bookingServices.createBooking(
        bookingData,
        token!,
      );

      if (!mounted) return;

      if (newBooking != null) {
        NotificationService.showSuccess(context, "Đặt dịch vụ thành công!");

        context.go(
          "/customer-asign-helper",
          extra: {"booking": newBooking, "token": widget.token},
        );
      } else {
        NotificationService.showSuccess(context, "Đặt dịch vụ thất bại!");
      }
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst("Exception: ", "");
      NotificationService.showError(context, message);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            const SizedBox(width: 8),

            // Text
            Flexible(
              child: Text(
                widget.title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ==== Address section ====
              AddressSection(initialAddress: _currentAddress),

              const SizedBox(height: 12),

              // ==== Description section ====
              DescriptionSection(description: widget.description),

              const SizedBox(height: 12),

              // ==== Working time section ====
              WorkingTimeSection(
                onDateChanged: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },

                onStartTimeChanged: (start) {
                  setState(() {
                    _startTime = start;
                  });
                },

                onEndTimeChanged: (end) {
                  setState(() {
                    _endTime = end;
                  });
                },

                onRecurringChanged: (isRecurring, recurringEndDate) {
                  setState(() {
                    _isRecursion = isRecurring;
                    _recursionDate = recurringEndDate;
                  });
                },
              ),

              const SizedBox(height: 12),

              // ==== Note section ====
              NoteSection(
                onChanged: (note) {
                  setState(() {
                    _note = note;
                  });
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // Section booking
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        // Decoration
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),

        child: SafeArea(
          child: Row(
            children: [
              // Button order
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: _isLoading ? null : _submitBooking,

                  // Text
                  child: const Text(
                    "Đặt dịch vụ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
