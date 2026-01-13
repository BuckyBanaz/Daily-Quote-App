<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Password Reset Successful - Daily Quote App</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #26A69A;
            --primary-dark: #00796B;
            --bg: #F0F4F8;
            --card-bg: #FFFFFF;
            --text-main: #1F2937;
            --text-muted: #6B7280;
            --success: #10B981;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background-color: var(--bg);
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            color: var(--text-main);
        }

        .container {
            width: 100%;
            max-width: 420px;
            padding: 20px;
        }

        .card {
            background: var(--card-bg);
            border-radius: 20px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
            padding: 40px;
            text-align: center;
        }

        .icon-box {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            background-color: #D1FAE5;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .icon-box svg {
            width: 40px;
            height: 40px;
            color: var(--success);
        }

        h1 {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 10px;
            color: var(--text-main);
        }

        p {
            font-size: 15px;
            color: var(--text-muted);
            line-height: 1.6;
            margin-bottom: 0;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="card">
        <div class="icon-box">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
        </div>
        
        <h1>All Set!</h1>
        <p>Your password has been successfully reset. You can now return to the app and login with your new credentials.</p>
    </div>
</div>

</body>
</html>
