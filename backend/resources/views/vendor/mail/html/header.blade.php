@props(['url'])
<tr>
    <td class="header" style="padding: 25px 0; text-align: center;">
        <a href="{{ $url }}" style="display: inline-block; text-decoration: none;">
            {{-- Try to show Logo, fallback to Text if needed (but primarily Logo) --}}
            {{-- Note: Local images won't show in Gmail/Outlook until hosted publically --}}
            <img src="{{ asset('images/logo.png') }}" class="logo" alt="QuoteVault" style="width: 80px; height: 80px; object-fit: contain; margin-bottom: 0;">
            <div style="color: #000; font-size: 24px; font-weight: bold; margin-top: 10px; font-family: 'Outfit', sans-serif;">QuoteVault</div>
        </a>
    </td>
</tr>
