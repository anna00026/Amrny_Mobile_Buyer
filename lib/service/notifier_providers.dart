import 'package:amrny/service/subscription_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:amrny/service/all_services_service.dart';
import 'package:amrny/service/app_string_service.dart';
import 'package:amrny/service/auth_services/apple_sign_in_sevice.dart';
import 'package:amrny/service/auth_services/change_pass_service.dart';
import 'package:amrny/service/auth_services/delete_account_service.dart';
import 'package:amrny/service/auth_services/email_verify_service.dart';
import 'package:amrny/service/auth_services/facebook_login_service.dart';
import 'package:amrny/service/auth_services/google_sign_service.dart';
import 'package:amrny/service/auth_services/login_service.dart';
import 'package:amrny/service/auth_services/logout_service.dart';
import 'package:amrny/service/auth_services/reset_password_service.dart';
import 'package:amrny/service/auth_services/signup_service.dart';
import 'package:amrny/service/book_confirmation_service.dart';
import 'package:amrny/service/book_steps_service.dart';
import 'package:amrny/service/booking_services/book_service.dart';
import 'package:amrny/service/booking_services/coupon_service.dart';
import 'package:amrny/service/booking_services/personalization_service.dart';
import 'package:amrny/service/booking_services/place_order_service.dart';
import 'package:amrny/service/booking_services/shedule_service.dart';
import 'package:amrny/service/country_states_service.dart';
import 'package:amrny/service/dropdowns_services/area_dropdown_service.dart';
import 'package:amrny/service/dropdowns_services/country_dropdown_service.dart';
import 'package:amrny/service/dropdowns_services/state_dropdown_services.dart';
import 'package:amrny/service/filter_category_service.dart';
import 'package:amrny/service/filter_services_service.dart';
import 'package:amrny/service/google_location_search_service.dart';
import 'package:amrny/service/home_services/category_service.dart';
import 'package:amrny/service/home_services/recent_services_service.dart';
import 'package:amrny/service/home_services/slider_service.dart';
import 'package:amrny/service/home_services/top_all_services_service.dart';
import 'package:amrny/service/home_services/top_rated_services_service.dart';
import 'package:amrny/service/jobs_service/create_job_service.dart';
import 'package:amrny/service/jobs_service/edit_job_country_states_service.dart';
import 'package:amrny/service/jobs_service/edit_job_service.dart';
import 'package:amrny/service/jobs_service/job_conversation_service.dart';
import 'package:amrny/service/jobs_service/job_request_service.dart';
import 'package:amrny/service/jobs_service/my_jobs_service.dart';
import 'package:amrny/service/jobs_service/recent_jobs_service.dart';
import 'package:amrny/service/leave_feedback_service.dart';
import 'package:amrny/service/live_chat/chat_list_service.dart';
import 'package:amrny/service/live_chat/chat_message_service.dart';
import 'package:amrny/service/my_orders_service.dart';
import 'package:amrny/service/order_details_service.dart';
import 'package:amrny/service/orders_service.dart';
import 'package:amrny/service/pay_services/bank_transfer_service.dart';
import 'package:amrny/service/pay_services/stripe_service.dart';
import 'package:amrny/service/payment_gateway_list_service.dart';
import 'package:amrny/service/permissions_service.dart';
import 'package:amrny/service/profile_edit_service.dart';
import 'package:amrny/service/profile_service.dart';
import 'package:amrny/service/push_notification_service.dart';
import 'package:amrny/service/report_services/report_message_service.dart';
import 'package:amrny/service/report_services/report_service.dart';
import 'package:amrny/service/rtl_service.dart';
import 'package:amrny/service/saved_items_service.dart';
import 'package:amrny/service/searchbar_with_dropdown_service.dart';
import 'package:amrny/service/seller_all_services_service.dart';
import 'package:amrny/service/service_details_service.dart';
import 'package:amrny/service/serviceby_category_service.dart';
import 'package:amrny/service/support_ticket/create_ticket_service.dart';
import 'package:amrny/service/support_ticket/support_messages_service.dart';
import 'package:amrny/service/support_ticket/support_ticket_service.dart';
import 'package:amrny/service/wallet_service.dart';

class NotifierProviders {
  static List<SingleChildWidget> getNotifierProviders() {
    return [
      ChangeNotifierProvider(create: (_) => CountryStatesService()),
      ChangeNotifierProvider(create: (_) => SignupService()),
      ChangeNotifierProvider(create: (_) => BookConfirmationService()),
      ChangeNotifierProvider(create: (_) => BookStepsService()),
      ChangeNotifierProvider(create: (_) => AllServicesService()),
      ChangeNotifierProvider(create: (_) => LoginService()),
      ChangeNotifierProvider(create: (_) => ResetPasswordService()),
      ChangeNotifierProvider(create: (_) => LogoutService()),
      ChangeNotifierProvider(create: (_) => ChangePassService()),
      ChangeNotifierProvider(create: (_) => ProfileService()),
      ChangeNotifierProvider(create: (_) => SliderService()),
      ChangeNotifierProvider(create: (_) => CategoryService()),
      ChangeNotifierProvider(create: (_) => TopRatedServicesSerivce()),
      ChangeNotifierProvider(create: (_) => ProfileEditService()),
      ChangeNotifierProvider(create: (_) => RecentServicesService()),
      ChangeNotifierProvider(create: (_) => SavedItemService()),
      ChangeNotifierProvider(create: (_) => ServiceDetailsService()),
      ChangeNotifierProvider(create: (_) => LeaveFeedbackService()),
      ChangeNotifierProvider(create: (_) => GoogleSignInService()),
      ChangeNotifierProvider(create: (_) => StripeService()),
      ChangeNotifierProvider(create: (_) => BankTransferService()),
      ChangeNotifierProvider(create: (_) => ServiceByCategoryService()),
      ChangeNotifierProvider(create: (_) => PersonalizationService()),
      ChangeNotifierProvider(create: (_) => BookService()),
      ChangeNotifierProvider(create: (_) => BookService()),
      ChangeNotifierProvider(create: (_) => SheduleService()),
      ChangeNotifierProvider(create: (_) => CouponService()),
      ChangeNotifierProvider(create: (_) => SearchBarWithDropdownService()),
      ChangeNotifierProvider(create: (_) => MyOrdersService()),
      ChangeNotifierProvider(create: (_) => PlaceOrderService()),
      ChangeNotifierProvider(create: (_) => FacebookLoginService()),
      ChangeNotifierProvider(create: (_) => SupportTicketService()),
      ChangeNotifierProvider(create: (_) => SupportMessagesService()),
      ChangeNotifierProvider(create: (_) => CreateTicketService()),
      ChangeNotifierProvider(create: (_) => EmailVerifyService()),
      ChangeNotifierProvider(create: (_) => OrderDetailsService()),
      ChangeNotifierProvider(create: (_) => RtlService()),
      ChangeNotifierProvider(create: (_) => TopAllServicesService()),
      ChangeNotifierProvider(create: (_) => PaymentGatewayListService()),
      ChangeNotifierProvider(create: (_) => AppStringService()),
      ChangeNotifierProvider(create: (_) => ChatListService()),
      ChangeNotifierProvider(create: (_) => ChatMessagesService()),
      ChangeNotifierProvider(create: (_) => MyJobsService()),
      ChangeNotifierProvider(create: (_) => CreateJobService()),
      ChangeNotifierProvider(create: (_) => EditJobService()),
      ChangeNotifierProvider(create: (_) => JobRequestService()),
      ChangeNotifierProvider(create: (_) => JobConversationService()),
      ChangeNotifierProvider(create: (_) => EditJobCountryStatesService()),
      ChangeNotifierProvider(create: (_) => OrdersService()),
      ChangeNotifierProvider(create: (_) => WalletService()),
      ChangeNotifierProvider(create: (_) => SellerAllServicesService()),
      ChangeNotifierProvider(create: (_) => PushNotificationService()),
      ChangeNotifierProvider(create: (_) => ReportService()),
      ChangeNotifierProvider(create: (_) => ReportMessagesService()),
      ChangeNotifierProvider(create: (_) => RecentJobsService()),
      ChangeNotifierProvider(create: (_) => PermissionsService()),
      ChangeNotifierProvider(create: (_) => CountryDropdownService()),
      ChangeNotifierProvider(create: (_) => StateDropdownService()),
      ChangeNotifierProvider(create: (_) => AreaDropdownService()),
      ChangeNotifierProvider(create: (_) => DeleteAccountService()),
      ChangeNotifierProvider(create: (_) => AppleSignInService()),
      ChangeNotifierProvider(create: (_) => GoogleLocationSearch()),
      ChangeNotifierProvider(create: (_) => FilterServicesService()),
      ChangeNotifierProvider(create: (_) => FilterCategoryService()),
      ChangeNotifierProvider(create: (_) => SubscriptionService()),
    ];
  }
}
