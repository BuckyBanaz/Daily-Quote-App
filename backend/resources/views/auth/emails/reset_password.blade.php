<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Outfit:wght@400;700&display=swap');
        body {
            font-family: 'Outfit', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            background-color: #f4f5f7;
            color: #52525b;
            margin: 0;
            padding: 0;
            width: 100% !important;
        }
        .wrapper {
            width: 100%;
            background-color: #f4f5f7;
            padding: 40px 0;
        }
        .content {
            max-width: 500px;
            margin: 0 auto;
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            overflow: hidden;
            padding: 40px;
            text-align: center;
        }
        .logo {
            margin-bottom: 20px;
        }
        h1 {
            color: #18181b;
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 20px;
            text-align: center;
        }
        p {
            font-size: 16px;
            line-height: 1.6;
            margin-bottom: 24px;
            color: #52525b;
        }
        .button {
            display: inline-block;
            background-color: #26A69A;
            color: #ffffff;
            padding: 14px 28px;
            border-radius: 30px;
            text-decoration: none;
            font-weight: bold;
            font-size: 16px;
            margin: 20px 0;
        }
        .footer {
            margin-top: 30px;
            font-size: 12px;
            color: #a1a1aa;
        }
        .brand-name {
            font-size: 24px;
            font-weight: bold;
            color: #000;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <div class="content">
            {{-- Embed the logo as a CID attachment --}}
            <div class="logo">
                <img src="{{ $message->embed(public_path('images/logo.png')) }}" alt="QuoteVault" style="width: 80px; height: 80px; object-fit: contain;">
                <div class="brand-name">QuoteVault</div>
            </div>

            <h1>Reset Password</h1>

            <p>Enter your new password below to assist you in getting back to your daily inspiration.</p>
            
            <p style="text-align: left; font-weight: bold; margin-bottom: 5px;">Email Address</p>
            <div style="background: #f9fafb; padding: 12px; border: 1px solid #e5e7eb; border-radius: 8px; text-align: left; margin-bottom: 20px; border: 1px solid #cfd0d4;">
                {{ $notifiable->email }}
            </div>

            <a href="{{ $url }}" class="button">Reset Password</a>

            <p style="font-size: 14px; color: #a1a1aa; margin-top: 20px;">
                If you did not request a password reset, no further action is required.
            </p>
        </div>
        
        <div class="footer">
            &copy; {{ date('Y') }} QuoteVault. All rights reserved.
        </div>
    </div>
</body>
</html>
