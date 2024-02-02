# Task Tracker

## Environment
- **Ruby:** 3.2.2
- **Rails:** 7.0.8
- **Database:** PostgreSQL

## Installation
1. **Clone the repository:**
    ```
    git clone https://github.com/tetianarozz/task-tracker.git
    ```
2. **Install dependencies:**
    ```
    bundle install
    ```

## Database Setup
1. **Create the database and run migrations:**
    ```
    rails db:setup
    ```

## Running the Server
- **Start the Rails server:**
    ```
    rails server
    ```

## Usage
- To interact with the API, use convenient tools such as Postman or cURL.

## API Endpoints

### User Authentication
- **POST /api/v1/sign_up**
- **POST /api/v1/sign_in**

### Projects
- **GET /api/v1/projects**
- **GET /api/v1/projects/:id**
- **GET /api/v1/projects/:id/tasks**
- **POST /api/v1/projects**
- **PUT /api/v1/projects/:id**
- **DELETE /api/v1/projects/:id**

### Tasks
- **GET /api/v1/tasks/:id**
- **POST /api/v1/tasks**
- **PUT /api/v1/tasks/:id**
- **DELETE /api/v1/tasks/:id**

### Authorization Headers:
- **X-User-Email:** User's email address
- **X-User-Token:** User's authentication token
