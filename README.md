# SPOS

Apa itu SPOS? SPOS atau _Store, Point of Sales_ adalah sebuah aplikasi yang akan menggabungkan
antara _Marketplace_ dengan aplikasi _Point of Sales_ itu sendiri.

> hah? gimana sih maksudnya?

_*Point of Sales*_ itu identik dengan pengoperasian antara produk-produk yang ingin dijual, dan juga
stock management ataupun _raw goods_ (bahan baku) jika produk tersebut berupa F&B.

Nah dari *POS* tersebut, aplikasi ini akan menghubungkan dengan marketplace yang ada di Indonesia,
seperti _Tokopedia_, _Shopee Indonesia_, dll.

Setiap pesanan dari Marketplace ataupun store offline ini akan selalu ter-integrasi dengan seksama.
Jadi jangan takut jika akan terjadinya _Product out of stock_ pada saat transaksi sudah berlangsung.

-----

## How to use

#### Step 1 : Clone Project
Download atau clone project ini dengan cara berikut
```bash
# ssh
git clone git@github.com:pandudpn/spos.git

# https
git clone git@github.com:pandudpn/spos.git
```

#### Step 2 : Install depedencies
Menuju ke project/repository yang baru saja kamu download/clone, lalu jalan syntax berikut
```bash
flutter pub get
```

#### Step 3 : Build injection
Project/repository ini menggunakan _*Injection*_ library yang akan melakukan otomatis men-generate
sebuah code. Jalankan syntax berikut agar _injection_ tersebut ter-generate
```bash
flutter pub run build_runner build
```