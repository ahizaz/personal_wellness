# App Store Rejection Fixes - Summary

সমস্ত App Store guideline issues সমাধান করা হয়েছে। নিচে কি কি change করা হয়েছে:

---

## ✅ Completed Fixes

### 1. Guideline 4.8 & 2.1 - Login
- **iOS-এ কোনো social login নেই** – শুধু Email/Password
- **Android-এ Google Sign In** আগের মতো কাজ করবে
- Backend এ Apple login লাগবে না

---

### 2. Guideline 2.3.8 - App Name Mismatch
- Device name এখন **"Skinspired Tracking"** (marketplace এর সাথে match)
- Info.plist এবং project.pbxproj update করা হয়েছে

---

### 3. Guideline 5.1.1(v) - Account Deletion
- **Account** screen এ "Delete account" option যোগ করা হয়েছে
- Tap করলে `https://skinspired.cloud/delete-account` open হবে

**আপনার করণীয়:**
- এই URL এ একটি webpage তৈরি করুন যেখানে user তাদের account delete করতে পারবে
- অথবা `Urls.deleteAccount` in `lib/core/urls/urls.dart` এ আপনার actual delete URL দিন

---

### 4. Guideline 1.4.1 - Medical Citations
- **Explore** screen এ "Sources & References" section যোগ করা হয়েছে (AAD, Mayo Clinic, NIH links)
- **Skin Condition** detail screen এও citation links যোগ করা হয়েছে

---

### 5. Guideline 5.1.2 - App Tracking Transparency
- App launch এ ATT permission request করা হয় (iOS)
- `main.dart` এ যোগ করা হয়েছে

**আপনার করণীয় (যদি app actually track না করে):**
- App Store Connect → App Privacy → Update করুন এবং mention করুন যে আপনি user track করেন না
- তাহলে ATT এর দরকার নাও পড়তে পারে

---

## Resubmit করার আগে Checklist

- [ ] Delete account page live আছে (বা `lib/core/urls/urls.dart` এ URL update করুন)
- [ ] App Store Connect এ test account দিন (Email/Password)
- [ ] Real device এ test করুন

---

## Files Changed

- `pubspec.yaml` - url_launcher
- `lib/core/urls/urls.dart` - applesignin, deleteAccount URLs
- `lib/feature/onboadring_create_account.dart/controller/sign_in_controller.dart` - Google crash fix
- `lib/feature/onboadring_create_account.dart/screen/name_age_gender.dart` - Google শুধু Android এ
- `lib/feature/onboadring_create_account.dart/screen/sign_in_form.dart` - Same
- `lib/feature/onboadring_create_account.dart/screen/register_form.dart` - Same
- `lib/feature/profile_accountseetings/screen/account.dart` - Delete account option
- `lib/feature/explore/screen/explore.dart` - Citations
- `lib/feature/explore/screen/skin_condition.dart` - Citations
- `lib/main.dart` - ATT at launch
- `ios/Runner/Info.plist` - Display name
- `ios/Runner.xcodeproj/project.pbxproj` - Display name
