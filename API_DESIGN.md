# API Design — Nhật kí của tôi (Personal Journal App)

## Tổng quan

Backend cung cấp REST API cho ứng dụng nhật kí cá nhân Flutter "Nhật kí của tôi".  
App cho phép người dùng ghi lại các trang nhật kí với tâm trạng, thẻ tag và đánh dấu yêu thích.

- **Framework:** Laravel 13
- **Database:** SQLite (`database/database.sqlite`)
- **Authentication:** Laravel Sanctum (token-based)
- **Base URL:** `http://localhost:8000/api`
- **Response format:** JSON
- **Encoding:** UTF-8

---

## 1. Thực thể dữ liệu & Quan hệ

### Bảng: `users`
| Cột | Kiểu | Ghi chú |
|-----|------|---------|
| id | bigint PK | Auto increment |
| name | string(100) | Tên hiển thị |
| email | string(150) UNIQUE | Email đăng nhập |
| password | string | Bcrypt hash |
| created_at | timestamp | |
| updated_at | timestamp | |

### Bảng: `journal_entries`
| Cột | Kiểu | Ghi chú |
|-----|------|---------|
| id | bigint PK | Auto increment |
| user_id | bigint FK → users.id | ON DELETE CASCADE |
| title | string(255) | Tiêu đề trang nhật kí |
| content | text | Nội dung đầy đủ |
| mood | string(20) | joyful / calm / focused / tired / sad |
| tags | json | Mảng chuỗi, ví dụ: ["công việc", "biết ơn"] |
| is_favorite | boolean | Mặc định false |
| created_at | timestamp | Ngày/giờ viết (dùng làm `date` trong Flutter) |
| updated_at | timestamp | |

### Quan hệ
- `User` **hasMany** `JournalEntry`
- `JournalEntry` **belongsTo** `User`

---

## 2. Giá trị hợp lệ cho `mood`

| Giá trị | Nhãn tiếng Việt | Emoji |
|---------|----------------|-------|
| `joyful` | Vui vẻ | 😊 |
| `calm` | Bình yên | 😌 |
| `focused` | Tập trung | 🧠 |
| `tired` | Mệt mỏi | 😮‍💨 |
| `sad` | Trầm lắng | 🥲 |

---

## 3. Authentication

Dùng **Laravel Sanctum** — token được gửi qua header `Authorization: Bearer {token}`.

### POST /api/auth/register

Đăng ký tài khoản mới.

**Request body:**
```json
{
  "name": "Nguyễn Văn A",
  "email": "user@example.com",
  "password": "password123",
  "password_confirmation": "password123"
}
```

**Validation:**
- `name`: required, string, max:100
- `email`: required, email, unique:users
- `password`: required, min:8, confirmed

**Response 201:**
```json
{
  "data": {
    "user": {
      "id": 1,
      "name": "Nguyễn Văn A",
      "email": "user@example.com",
      "created_at": "2026-04-16T10:00:00Z"
    },
    "token": "1|abc123..."
  }
}
```

**Response 422** (validation error):
```json
{
  "message": "The email has already been taken.",
  "errors": {
    "email": ["The email has already been taken."]
  }
}
```

---

### POST /api/auth/login

Đăng nhập, nhận token.

**Request body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Validation:**
- `email`: required, email
- `password`: required, string

**Response 200:**
```json
{
  "data": {
    "user": {
      "id": 1,
      "name": "Nguyễn Văn A",
      "email": "user@example.com",
      "created_at": "2026-04-16T10:00:00Z"
    },
    "token": "2|xyz456..."
  }
}
```

**Response 401** (sai thông tin):
```json
{
  "message": "Email hoặc mật khẩu không đúng."
}
```

---

### POST /api/auth/logout *(requires auth)*

Xoá token hiện tại.

**Headers:** `Authorization: Bearer {token}`

**Response 200:**
```json
{
  "message": "Đã đăng xuất thành công."
}
```

---

### GET /api/auth/me *(requires auth)*

Lấy thông tin người dùng hiện tại.

**Headers:** `Authorization: Bearer {token}`

**Response 200:**
```json
{
  "data": {
    "id": 1,
    "name": "Nguyễn Văn A",
    "email": "user@example.com",
    "created_at": "2026-04-16T10:00:00Z"
  }
}
```

---

## 4. Journal Entries API *(tất cả đều yêu cầu auth)*

### GET /api/entries

Lấy danh sách tất cả nhật kí của user hiện tại, sắp xếp mới nhất trước.

**Headers:** `Authorization: Bearer {token}`

**Query params (tuỳ chọn):**
| Param | Kiểu | Mô tả |
|-------|------|-------|
| `q` | string | Tìm kiếm trong title và content |
| `mood` | string | Lọc theo mood (joyful/calm/focused/tired/sad) |
| `favorite` | boolean | Lọc chỉ bài yêu thích (`1` hoặc `true`) |

**Response 200:**
```json
{
  "data": [
    {
      "id": 1,
      "title": "Một ngày thật nhiều năng lượng",
      "content": "Hôm nay tôi đã hoàn thành...",
      "preview": "Hôm nay tôi đã hoàn thành...",
      "mood": "joyful",
      "tags": ["công việc", "biết ơn"],
      "is_favorite": false,
      "created_at": "2026-04-16T08:30:00Z",
      "updated_at": "2026-04-16T08:30:00Z"
    }
  ]
}
```

**Ghi chú:** `preview` là 120 ký tự đầu của `content`, thêm "..." nếu dài hơn.

---

### POST /api/entries

Tạo trang nhật kí mới.

**Headers:** `Authorization: Bearer {token}`

**Request body:**
```json
{
  "title": "Một ngày thật nhiều năng lượng",
  "content": "Hôm nay tôi đã hoàn thành rất nhiều việc quan trọng...",
  "mood": "joyful",
  "tags": ["công việc", "biết ơn"]
}
```

**Validation:**
- `title`: required, string, max:255
- `content`: required, string, min:20
- `mood`: required, in:joyful,calm,focused,tired,sad
- `tags`: nullable, array, max:10 items
- `tags.*`: string, max:50

**Response 201:**
```json
{
  "data": {
    "id": 5,
    "title": "Một ngày thật nhiều năng lượng",
    "content": "Hôm nay tôi đã hoàn thành rất nhiều việc quan trọng...",
    "preview": "Hôm nay tôi đã hoàn thành rất nhiều việc quan trọng...",
    "mood": "joyful",
    "tags": ["công việc", "biết ơn"],
    "is_favorite": false,
    "created_at": "2026-04-16T10:15:00Z",
    "updated_at": "2026-04-16T10:15:00Z"
  }
}
```

**Response 422** (validation error): standard Laravel format.

---

### GET /api/entries/{id}

Lấy chi tiết một trang nhật kí.

**Headers:** `Authorization: Bearer {token}`

**Response 200:** (cùng shape với item trong list)

**Response 403:** nếu entry không thuộc về user hiện tại.

**Response 404:** nếu không tìm thấy.

---

### PUT /api/entries/{id}

Cập nhật trang nhật kí. Chấp nhận partial update (chỉ gửi field cần đổi).

**Headers:** `Authorization: Bearer {token}`

**Request body (tất cả optional):**
```json
{
  "title": "Tiêu đề mới",
  "content": "Nội dung cập nhật...",
  "mood": "calm",
  "tags": ["suy ngẫm"],
  "is_favorite": true
}
```

**Validation (tất cả `sometimes`):**
- `title`: string, max:255
- `content`: string, min:20
- `mood`: in:joyful,calm,focused,tired,sad
- `tags`: array, max:10 items
- `tags.*`: string, max:50
- `is_favorite`: boolean

**Response 200:** entry đã cập nhật (cùng shape với GET).

**Response 403 / 404:** như trên.

---

### DELETE /api/entries/{id}

Xoá trang nhật kí.

**Headers:** `Authorization: Bearer {token}`

**Response 200:**
```json
{
  "message": "Đã xoá trang nhật kí."
}
```

**Response 403 / 404:** như trên.

---

### PATCH /api/entries/{id}/favorite

Toggle trạng thái yêu thích (đảo ngược `is_favorite` hiện tại).

**Headers:** `Authorization: Bearer {token}`

**Response 200:**
```json
{
  "data": {
    "id": 1,
    "is_favorite": true
  }
}
```

---

## 5. Stats API *(yêu cầu auth)*

### GET /api/stats

Lấy thống kê của người dùng hiện tại dùng cho HomeScreen và ProfileScreen.

**Headers:** `Authorization: Bearer {token}`

**Response 200:**
```json
{
  "data": {
    "total_entries": 12,
    "favorites_count": 3,
    "unique_tags_count": 7,
    "mood_distribution": {
      "joyful": 4,
      "calm": 3,
      "focused": 2,
      "tired": 2,
      "sad": 1
    },
    "top_mood": "joyful",
    "recent_entries": [
      {
        "id": 12,
        "title": "Ngày cuối tuần yên bình",
        "preview": "Sáng nay thức dậy muộn, uống cà phê nhìn mưa...",
        "mood": "calm",
        "tags": ["thư giãn"],
        "is_favorite": false,
        "created_at": "2026-04-16T08:00:00Z"
      }
    ]
  }
}
```

**Ghi chú:**
- `recent_entries`: 3 bài mới nhất (dùng cho HomeScreen)
- `top_mood`: mood có số lần xuất hiện cao nhất; nếu bằng nhau thì lấy mood có thứ tự ưu tiên trong enum Flutter (joyful > calm > focused > tired > sad)
- `unique_tags_count`: tổng số tag khác nhau trong toàn bộ entries của user

---

## 6. Error Response Format

Tất cả lỗi trả về theo format nhất quán:

```json
{
  "message": "Mô tả lỗi ngắn gọn.",
  "errors": {
    "field": ["Chi tiết lỗi validation."]
  }
}
```

`errors` chỉ có mặt trong response 422 (validation failed).

### HTTP Status Codes

| Code | Ý nghĩa |
|------|---------|
| 200 | Thành công |
| 201 | Tạo mới thành công |
| 401 | Chưa xác thực (thiếu / sai token) |
| 403 | Không có quyền truy cập resource |
| 404 | Không tìm thấy resource |
| 422 | Validation failed |
| 500 | Lỗi server |

---

## 7. Ghi chú tích hợp Frontend

| Frontend field | Backend field | Ghi chú |
|---------------|---------------|---------|
| `entry.id` (String) | `id` (int) | Frontend dùng String, backend trả int — Flutter cần `.toString()` hoặc parse |
| `entry.date` (DateTime) | `created_at` (ISO 8601) | Frontend dùng `date`, backend dùng `created_at` |
| `entry.mood` (MoodType enum) | `mood` (string) | Dùng `.name` của enum khi gửi, parse lại khi nhận |
| `entry.tags` (List<String>) | `tags` (json array) | Tương thích hoàn toàn |
| `entry.isFavorite` (bool) | `is_favorite` (bool) | Tên khác nhau — cần mapping |

**Lưu ý khi tích hợp:**
- Khi tạo entry, frontend hiện dùng `DateTime.now().millisecondsSinceEpoch.toString()` làm ID — sau khi kết nối backend, sẽ dùng ID trả về từ server.
- Token nên được lưu trong `flutter_secure_storage` hoặc `hive` (đã có dependency).
- Tất cả request cần header `Accept: application/json` để Laravel trả JSON thay vì HTML khi có lỗi.

---

## 8. Chạy backend

```bash
cd backend
cp .env.example .env
php artisan key:generate
php artisan migrate --seed
php artisan serve
```

Server chạy tại: `http://localhost:8000`

**Demo account (sau khi seed):**
- Email: `demo@nhatky.app`
- Password: `password`

**Lưu ý:** File `.env` trong repo đã được cấu hình sẵn với SQLite. Chỉ cần chạy `php artisan key:generate` rồi migrate là dùng được ngay.
