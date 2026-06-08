# Invoicing App - Django Backend

## Setup Instructions

### 1. Install Python (3.10+)

### 2. Install dependencies
```
pip install django djangorestframework djangorestframework-simplejwt django-cors-headers
```

### 3. Run migrations
```
python manage.py makemigrations
python manage.py migrate
```

### 4. Create admin superuser
```
python manage.py createsuperuser
```
Fill: username, email, phone_number, password

### 5. Run server
```
python manage.py runserver
```
Server runs at: http://127.0.0.1:8000

---

## API Endpoints

### Auth
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/users/register/ | Register new user |
| POST | /api/users/login/ | Login (returns JWT token) |
| GET  | /api/users/me/ | Get current user info |

### Admin Only
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/users/ | List all users |
| POST | /api/users/{id}/approve/ | Approve a user |
| DELETE | /api/users/{id}/delete/ | Delete a user |
| GET | /api/invoices/admin/all/ | View all invoices |

### User (must be approved + logged in)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/items/ | List my items |
| POST | /api/items/ | Add new item |
| DELETE | /api/items/{id}/delete/ | Delete item |
| GET | /api/invoices/ | List my invoices |
| POST | /api/invoices/ | Create invoice |
| DELETE | /api/invoices/{id}/delete/ | Delete invoice |

---

## Login Flow
1. User registers → waits for admin approval
2. Admin approves via /api/users/{id}/approve/
3. User logs in → gets JWT token
4. Use token in header: `Authorization: Bearer <token>`
