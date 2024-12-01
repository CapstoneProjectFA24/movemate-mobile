class APIConstants {
  static const baseUrl = "https://api.movemate.info/api/v1";
  static const contentType = 'application/json';
  static const contentHeader = 'Content-Type';
  static const authHeader = 'Authorization';
  static const prefixToken = 'bearer ';

  // auth
  static const login = '/authentications/login';
  static const register = '/authentications/registeration';
  static const checkExists = '/authentications/check-exists';
  static const verifyToken = '/authentications/verify-token';
  static const reGenerateToken = '/authentications/re';

  // Booking endpoints
  // static const get_truck_category = '/truckcategorys';
  static const get_truck_category = '/truckcategorys';
  static const get_service_truck_cate = '/services/truck-category';
  static const get_service_not_type_truck = '/services/not-type-truck';
  static const get_fees_system = '/fees/system';
  static const get_house_types = '/housetypes';
  static const get_all_package_services = '/services';
  static const post_valuation_booking_service = '/bookings/valuation-booking';

//post booking

  static const post_booking_service = '/bookings/register-booking';
  // static const post_booking_service = '/bookings/register-booking';
  static const confirm_review = '/bookings/user/confirm';
  static const cancel_booking = '/bookings/cancel-booking';

  // order

  static const bookings = '/bookings';
  static const bookings_old = '/bookings/old-booking';
//get list truck
  static const get_list_truck = '/services';
//get list truck
  static const get_list_truck_cate = '/services/truck-category';
  // payments
  static const paymentsBooking = '/payments';
  static const paymentsDeposit = '/wallets/recharge';
  //wallet
  static const get_wallet = '/wallets/balance';
// promotions
  static const promotions = '/promotions';

//get user
  static const get_user = '/users';
  // api vietmap-key
  // static const apiVietMapKey =
  //     "be00f7e132bdd086ccd57e21460209836f5d37ce56beaa42";
  // api vietmap-key backup
  static const apiVietMapKey =
      "be00f7e132bdd086ccd57e21460209836f5d37ce56beaa42";

  // api vietmap-key backup-v2
  // static const apiVietMapKey =
  //     "e7fb2f56a9eca6890aae01882c6b789527a21dcf88c75145";

  // error
  static const Map<String, String> errorTrans = {
    'Email is already registered.': 'Email này đã được đăng kí.',
    'Phone number is already registered.': 'Số điện thoại này đã được đăng kí.',
    'Email already exists.': 'Email này đã tồn tại.',
    'Invalid email/phone number or password':
        'Thông tin đăng nhập không chính xác.',
    'Phone already exists.': 'Số điện thoại này đã tồn tại.',
    'Email does not exist in the system.':
        'Email không tồn tại trong hệ thống.',
    'Email or Password is invalid.': 'Email hoặc mật khẩu không hợp lệ.',
    'Your OTP code does not match the previously sent OTP code.':
        'Mã OTP bạn nhập không đúng.',
    'Email is invalid Email format.': 'Email sai định dạng.',
    'OTP code has expired.': 'Mã OTP đã hết hạn.',
    'Email has not been previously authenticated.': 'Email chưa được xác thực.',
    'Email is not yet authenticated with the previously sent OTP code.':
        'Email chưa được xác thực bằng mã OTP.',
    'You are not allowed to access this function!':
        'Bạn không có quyền truy cập chức năng này.',
    'Rejected Reason is not empty.': 'Lý do từ chối không được để trống.',
    "An unexpected error occurred": "Đã xảy ra lỗi không mong muốn.",
    "Token cannnot be empty": "Token không được để trống.",
    "Return URL is required": "URL trả về là bắt buộc.",
    "Payment method is required and must be a valid value":
        "Phương thức thanh toán là bắt buộc và phải hợp lệ.",
    "Invalid callback data": "Dữ liệu callback không hợp lệ.",
    "Unsupported payment method selected":
        "Phương thức thanh toán không được hỗ trợ.",
    "Server URL is not available": "URL của máy chủ không khả dụng.",
    "User info has been deleted": "Thông tin người dùng đã bị xóa.",
    "User info with this type has existed":
        "Thông tin người dùng với loại này đã tồn tại.",
    "This account has been banned": "Tài khoản này đã bị cấm.",
    "The input Id must match the request Id":
        "ID đầu vào phải khớp với ID yêu cầu.",
    "User have no permission": "Người dùng không có quyền truy cập.",
    "Invalid user ID in token": "ID người dùng không hợp lệ trong token.",
    "List user is empty!": "Danh sách người dùng trống!",
    "User not found!": "Không tìm thấy người dùng!",
    "Update user failed": "Cập nhật người dùng thất bại.",
    "The phone number does not exist": "Số điện thoại không tồn tại.",
    "The email or phone number does not exist":
        "Email hoặc số điện thoại không tồn tại.",
    "Invalid status provided or cannot transition from the current status":
        "Trạng thái không hợp lệ hoặc không thể chuyển đổi từ trạng thái hiện tại.",
    "Booking not found": "Không tìm thấy đặt đơn.",
    "Booking is not from this user": "Đơn đặt không thuộc về người dùng này.",
    "Invalid booking details list, must contain at least 1 element":
        "Danh sách chi tiết đặt đơn không hợp lệ, phải chứa ít nhất 1 phần tử.",
    "Booking have been canceled": "Đơn đặt đã bị hủy.",
    "Amount must be greater than zero": "Số tiền phải lớn hơn 0.",
    "Invalid payment signature": "Chữ ký thanh toán không hợp lệ.",
    "Payment was not successful": "Thanh toán không thành công.",
    "Voucher not found": "Không tìm thấy voucher.",
    "Voucher already deleted": "Voucher đã bị xóa.",
    "Field is required": "Trường là bắt buộc.",
    "Invalid format": "Định dạng không hợp lệ.",

    // User Errors
    'Email is already registered': 'Email này đã được đăng kí.',
    'Phone number is already registered': 'Số điện thoại này đã được đăng kí.',
    'Role not found': 'Không tìm thấy vai trò.',
    'Update user info failed': 'Cập nhật thông tin người dùng thất bại.',
    'User is not a driver': 'Người dùng không phải tài xế.',
    'The user has already registered a truck': 'Người dùng đã đăng kí xe tải.',
    'You do not have permission to perform this operation':
        'Bạn không có quyền thực hiện thao tác này.',
    'This user cannot be added to the group':
        'Người dùng này không thể được thêm vào nhóm.',

    // Booking Errors
    'Booking detail not found': 'Không tìm thấy chi tiết đặt đơn.',
    'Time is not null and whether the value is greater than or equal to the current time':
        'Thời gian không hợp lệ hoặc nhỏ hơn hiện tại.',
    'Add booking failed': 'Thêm đặt đơn thất bại.',
    'Cannot update to the next status from the current status':
        'Không thể cập nhật trạng thái tiếp theo từ trạng thái hiện tại.',
    'Booking ID is required and must be greater than 0':
        'ID đặt đơn là bắt buộc và phải lớn hơn 0.',
    'Update booking failed': 'Cập nhật đặt đơn thất bại.',
    'Expired - Automatically canceled by system':
        'Đã hết hạn - Hệ thống tự động hủy.',
    'Is expired, Cancel by System': 'Đã hết hạn, hệ thống đã hủy.',
    'Booking has not been updated Estimated Delivery Time yet':
        'Đặt đơn chưa được cập nhật thời gian giao hàng ước tính.',
    'Currently there are no suitable drivers': 'Hiện không có tài xế phù hợp.',
    'Drivers or porters cannot be added to the booking':
        'Không thể thêm tài xế hoặc người khuân vác vào đơn đặt.',

    // Assignment Errors
    'Assignment not found': 'Không tìm thấy phân công.',
    'The assignment status must be SUGGESTED':
        'Trạng thái phân công phải là ĐỀ XUẤT.',
    'The assignment status must be WAITING':
        'Trạng thái phân công phải là ĐANG CHỜ.',
    'Booking is not from this reviewer':
        'Đặt đơn không thuộc về người đánh giá này.',
    'Booking detail is completely fine': 'Chi tiết đặt đơn hoàn toàn ổn.',
    'Manual assignment Faild': 'Phân công thủ công thất bại.',
    'The staff member is already assigned to this booking.':
        'Nhân viên đã được phân công vào đặt đơn này.',

    // Other Errors
    'Wallet not found': 'Không tìm thấy ví.',
    'Failed to update wallet balance': 'Cập nhật số dư ví thất bại.',

    // General Success Messages
    'Login successful': 'Đăng nhập thành công.',
    'Token verification successful': 'Xác minh token thành công.',
    'Success': 'Thành công.',
    'Customer information is available': 'Thông tin khách hàng có sẵn.',
    'User registered successfully': 'Người dùng đã đăng ký thành công.',
    'Get list user done': 'Lấy danh sách người dùng thành công.',
    'Get list user info done': 'Lấy thông tin danh sách người dùng thành công.',
    'User information retrieved successfully':
        'Thông tin người dùng đã được lấy thành công.',
    'Create user successful': 'Tạo người dùng thành công.',
    'User has been banned': 'Người dùng đã bị cấm.',
    'Create a new user info successful':
        'Tạo thông tin người dùng mới thành công.',
    'Update user info succesful': 'Cập nhật thông tin người dùng thành công.',
    'Get user done': 'Lấy người dùng thành công.',

    // Booking
    'List booking is empty!': 'Danh sách đặt đơn trống.',
    'Get list booking done': 'Lấy danh sách đặt đơn thành công.',
    'Get booking successfully': 'Lấy đặt đơn thành công.',
    'Add booking successed': 'Thêm đặt đơn thành công.',
    'Valuation!': 'Định giá thành công.',
    'Cancel booking successed': 'Hủy đặt đơn thành công.',
    'Status updated successfully': 'Cập nhật trạng thái thành công.',
    'Confirm round trip successfully': 'Xác nhận chuyến đi khứ hồi thành công.',
    'Update booking succesful': 'Cập nhật đặt đơn thành công.',
    'Update booking detail succesful': 'Cập nhật chi tiết đặt đơn thành công.',
    'Get Driver successful': 'Lấy danh sách tài xế thành công.',
    'Get Porter successful': 'Lấy danh sách người khuân vác thành công.',

    // Fee Setting
    'List fee setting is empty!': 'Danh sách thiết lập phí trống.',
    'Get list fee setting done': 'Lấy danh sách thiết lập phí thành công.',
    'Get truck category successfully': 'Lấy danh mục xe tải thành công.',
    'Fee setting has been deleted': 'Thiết lập phí đã bị xóa.',

    // House Type
    'List house type is empty!': 'Danh sách loại nhà trống.',
    'Get list house type done': 'Lấy danh sách loại nhà thành công.',
    'Get house type successfully': 'Lấy loại nhà thành công.',
    'Add house type setting successed': 'Thêm thiết lập loại nhà thành công.',
    'House type has been deleted': 'Loại nhà đã bị xóa.',

    // Schedule
    'List schedule is empty!': 'Danh sách lịch trình trống.',
    'Get list schedule done': 'Lấy danh sách lịch trình thành công.',
    'Get schedule successfully': 'Lấy lịch trình thành công.',
    'List schedule working is empty!': 'Danh sách lịch làm việc trống.',
    'Get list schedule working done': 'Lấy danh sách lịch làm việc thành công.',
    'Get schedule working successfully': 'Lấy lịch làm việc thành công.',
    'Schedule working has been deleted': 'Lịch làm việc đã bị xóa.',
    'Create a new schedule working successful':
        'Tạo lịch làm việc mới thành công.',
    'Update truck category succesful': 'Cập nhật danh mục xe tải thành công.',

    // Truck
    'List truck is empty!': 'Danh sách xe tải trống.',
    'Get list truck done': 'Lấy danh sách xe tải thành công.',
    'Get truck successfully': 'Lấy xe tải thành công.',
    'Truck image has been deleted': 'Hình ảnh xe tải đã bị xóa.',
    'Create a new truck image successful':
        'Tạo hình ảnh xe tải mới thành công.',
    'Truck category has been deleted': 'Danh mục xe tải đã bị xóa.',
    'Create a new truck category successful':
        'Tạo danh mục xe tải mới thành công.',
    'Booking do not need porter': 'Đặt đơn không cần người khuân vác.',
    'Booking do not need driver': 'Đặt đơn không cần tài xế.',

    // Group
    'Group has been deleted': 'Nhóm đã bị xóa.',
    'List group is empty!': 'Danh sách nhóm trống.',
    'Get list group done': 'Lấy danh sách nhóm thành công.',
    'Get group successfully': 'Lấy nhóm thành công.',
    'Create a new group successful': 'Tạo nhóm mới thành công.',
    'Add user into group successful': 'Thêm người dùng vào nhóm thành công.',
    'Add group into schedule successful':
        'Thêm nhóm vào lịch trình thành công.',

    // Wallet
    'Wallet retrieved successfully': 'Lấy thông tin ví thành công.',
    'Wallet updated successfully': 'Cập nhật ví thành công.',

    // Payment
    'Payment link created successfully':
        'Đã tạo liên kết thanh toán thành công.',
    'Payment handled successfully': 'Xử lý thanh toán thành công.',
    'Payment booking successful': 'Đặt đơn thanh toán thành công.',

    // Transaction
    'Transaction has already been processed': 'Giao dịch đã được xử lý.',
    'List transaction is empty!': 'Danh sách giao dịch trống.',
    'Get list transaction done': 'Lấy danh sách giao dịch thành công.',

    // Service
    'Create a new service successful': 'Tạo dịch vụ mới thành công.',
    'Service has been deleted': 'Dịch vụ đã bị xóa.',
    'Update service succesful': 'Cập nhật dịch vụ thành công.',
    'List service is empty!': 'Danh sách dịch vụ trống.',
    'Get list service done': 'Lấy danh sách dịch vụ thành công.',
    'Get service successfully': 'Lấy dịch vụ thành công.',

    // Tracker Source
    'Tracker source has been deleted': 'Nguồn theo dõi đã bị xóa.',
    'Add tracker successful': 'Thêm theo dõi thành công.',

    // Notification
    'Created User Device Successfully.': 'Tạo thiết bị người dùng thành công.',
    'Delete User Device Successfully.': 'Xóa thiết bị người dùng thành công.',
    'Notification have been read': 'Thông báo đã được đọc.',
    'List notification is empty!': 'Danh sách thông báo trống.',
    'Get list notification done': 'Lấy danh sách thông báo thành công.',

    // payment-error
    "Booking status must be either DEPOSITING or COMPLETED":
        "Trạng thái đặt đơn đã hoàn thành"
  };
}
