# 🏡 MoveMate

MoveMate là ứng dụng giúp bạn dễ dàng dọn dẹp và vận chuyển nhà một cách hiệu quả và tiện lợi. Với giao diện thân thiện và các tính năng mạnh mẽ, MoveMate hỗ trợ bạn quản lý quá trình dọn dẹp và chuyển nhà từ A đến Z.

![MoveMate Banner]([https://res.cloudinary.com/dkpnkjnxs/image/upload/v1732365346/movemate_logo_esm5fx.png])

## 📦 Tính Năng

- **Đặt hàng dọn nhà:** tạo đơn dọn nhà nhanh chóng với các dịch vụ chuyên nghiệp.
- **Theo dõi Vận Chuyển:** Theo dõi tiến độ vận chuyển đồ đạc từ địa điểm cũ đến mới.
- **Thông Báo Thông Minh:** Nhận thông báo về đơn hàng và cập nhật trạng thái.
- **Đồng Bộ Hóa Dữ Liệu:** Lưu trữ và truy cập dữ liệu mọi lúc, mọi nơi thông qua Firebase.
- **Giao Diện Thân Thiện:** Thiết kế hiện đại, dễ sử dụng với frameWork flutter.

## 🚀 Công Nghệ Sử Dụng

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![REST API](https://img.shields.io/badge/REST_API-4FC08D?style=for-the-badge&logo=restapi&logoColor=white)
![Cloudinary](https://img.shields.io/badge/Cloudinary-1D9BF0?style=for-the-badge&logo=cloudinary&logoColor=white)
![VietMap](https://img.shields.io/badge/VietMap-FF5733?style=for-the-badge&logo=map&logoColor=white)

- **Flutter:** Framework Flutter mạnh mẽ cho phát triển ứng dụng mobile đa nền tảng.
- **Firebase:** Cơ sở dữ liệu thời gian thực và xác thực người dùng, hỗ trợ nhiều tính năng backend.
- **REST API:** Giao tiếp giữa client và server hiệu quả, đảm bảo tính mở rộng và dễ bảo trì.
- **Cloudinary:** Quản lý và xử lý hình ảnh linh hoạt, tối ưu hóa tải trọng và hiệu suất ứng dụng.
- **VietMap:** Cung cấp bản đồ địa phương chi tiết và chính xác, hỗ trợ tính năng định vị và dẫn đường.

## 🛠️ Cài Đặt

### Yêu Cầu

- Flutter version 3.24.5 hoặc mới hơn
- Dart version 3.5.4
- Android SDK version 17.0.10
- API key VietMap
- Tài khoản Firebase

### Bước 1: Clone Repository

```bash
git clone https://github.com/CapstoneProjectFA24/movemate-mobile.git
cd movemate-mobile
```

### Bước 2: Cài Đặt Dependencies

- flutter pub get
- flutter packages pub run build_runner build

### Bước 3: Cấu Hình và setup firebase

1-dart pub global activate flutterfire_cli
2-flutterfire configure

link.startsWith('movemate://payment-result')
link.startsWith('Your_link_response_after_payment')

apiVietMapKey =
"38db2f3d058b34e0f52f067fe66a902830fac1a044e8d444"
apiVietMapKey =
"Your_API_key"

📝 Hướng Dẫn Sử Dụng
Đăng Ký / Đăng Nhập: Tạo tài khoản hoặc đăng nhập vào MoveMate.
Tạo đơn hàng Dọn Dẹp:

- Thêm thông tin về địa điểm cũ và mới
- chọn loại xe phù hợp
- chọn loại dịch vụ cần chuyển.

Theo dõi Vận Chuyển: Theo dõi tiến độ vận chuyển.
Theo Dõi Tiến Độ: Xem trạng thái đơn hàng và điều chỉnh thời gian đặt hàng khi cần thiết.

📄 License
MoveMate được phát hành dưới MIT License.

📫 Liên Hệ
Nếu bạn có bất kỳ câu hỏi hoặc góp ý nào, vui lòng liên hệ với chúng tôi qua email: <phantuan.tech@gmail.com>

# rule

1/ run command: flutter packages pub run build_runner build (if change or adding new route)

2/ syntax open emulator nhanh: Ctrl + P => >flu...

2/ run project: flutter run

git checkout refactor/ui-booking
git push origin refactor/ui-booking

3/ setup firebase

1-dart pub global activate flutterfire_cli
2-flutterfire configure
