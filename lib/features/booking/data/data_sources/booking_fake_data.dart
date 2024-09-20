// fakedata b

const String fakeBookingJson = '''
{
  "houseType": "Nhà riêng",
  "numberOfRooms": 3,
  "numberOfFloors": 2,
  "livingRoomImages": ["assets/images/booking/bedroom/bedroom1.png", "assets/images/booking/bedroom/bedroom2.png"],
  "bedroomImages": ["assets/images/booking/bedroom/bedroom3.png"],
  "diningRoomImages": [],
  "officeRoomImages": [],
  "bathroomImages": [],
  "totalPrice": 100.0,
  "selectedVehicleIndex": 1,
  "selectedPackageIndex": 0,
  "packagePrice": 50.0,
  "peopleCount": 2,
  "airConditionersCount": 1,
  "isRoundTrip": false,
  "notes": "Sample note"
}
''';

// vehicle_fake_data.dart

const String fakeVehicleJson = '''[

    {
      "categoryName": "Medium Truck",
      "maxLoad": 1500,
      "description": "Truck suitable for medium loads",
      "imgUrl":"https://cdn-icons-png.flaticon.com/512/306/306865.png",
      "estimatedLength": "6.0m",
      "estimatedWidth": "2.5m",
      "estimatedHeight": "3.0m",
      "summarize": "Ideal for medium transport",
      "price": 500000
    },
    {
      "categoryName": "Large Truck",
      "maxLoad": 3000,
      "description": "Truck suitable for large loads",
      "imgUrl": "https://cdn-icons-png.flaticon.com/512/306/306865.png",
      "estimatedLength": "8.0m",
      "estimatedWidth": "3.0m",
      "estimatedHeight": "3.5m",
      "summarize": "Ideal for large transport",
      "price": 800000
    }
]

''';

const String fakeBookingJson2nd = '''[
   {
      "packageTitles":"Gói hỗ trợ chuyển nhà cơ bản",
      "packagePrices":"730.000đ",
      "packageIcons":"assets/images/package_icon.png",
      "service":[
         {
            "title": "Bốc xếp (Bởi tài xế)",
            "price":"120.000đ"
         },
         {
            "title":"Bốc xếp (Có người hỗ trợ)",
            "price":"200.000đ"
         }
      ]
   },
   {
      "packageTitles":"Gói hỗ trợ chuyển nhà 1 chiều",
      "packagePrices":"660.000đ",
      "packageIcons":"assets/images/package_icon2.png",
      "service":[
         {
            "title": "Bốc xếp (Bởi tài xế)",
            "price":"120.000đ"
         },
         {
            "title":"Bốc xếp (Có người hỗ trợ)",
            "price":"200.000đ"
         }
      ]
   },
   {
      "packageTitles":"Gói hỗ trợ chuyển nhà 2 chiều",
      "packagePrices":"860.000đ",
      "packageIcons":"assets/images/package_icon3.png",
      "service":[
         {
            "title": "Bốc xếp (Bởi tài xế)",
            "price":"120.000đ"
         },
         {
            "title":"Bốc xếp (Có người hỗ trợ)",
            "price":"200.000đ"
         }
      ]
   }
]''';
