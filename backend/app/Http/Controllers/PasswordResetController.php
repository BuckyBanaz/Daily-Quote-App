<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Password;
use Illuminate\Support\Facades\Hash;
use Illuminate\Auth\Events\PasswordReset;
use Illuminate\Support\Str;
use OpenApi\Annotations as OA;

class PasswordResetController extends Controller
{
    /**
     * Send a reset link to the given user.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function sendResetLink(Request $request)
    {
        $request->validate(['email' => 'required|email']);

        // We will send the password reset link to this user. Once we have attempted
        // to send the link, we will examine the response then see the message we
        // need to return to the user. Finally, we'll send out a proper response.
        $status = Password::sendResetLink(
            $request->only('email')
        );

        return $status === Password::RESET_LINK_SENT
            ? response()->json(['success' => true, 'message' => __($status)])
            : response()->json(['success' => false, 'message' => __($status)], 400);
    }

    /**
     * Display the password reset view for the given token.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  string|null  $token
     * @return \Illuminate\Contracts\View\Factory|\Illuminate\View\View
     */
    public function showResetForm(Request $request, $token = null)
    {
        return view('auth.reset-password')->with(
            ['token' => $token, 'email' => $request->email]
        );
    }

    /**
     * Reset the given user's password.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\RedirectResponse|\Illuminate\Http\JsonResponse
     */
    public function reset(Request $request)
    {
        $request->validate([
            'token' => 'required',
            'email' => 'required|email',
            'password' => 'required|confirmed|min:8',
        ]);

        // Here we will attempt to reset the user's password. If it is successful we
        // will update the password on an actual user model and persist it to the
        // database. Otherwise we will parse the error and return the response.
        $status = Password::reset(
            $request->only('email', 'password', 'password_confirmation', 'token'),
            function ($user, $password) {
                $user->forceFill([
                    'password' => Hash::make($password)
                ])->setRememberToken(Str::random(60));

                $user->save();

                event(new PasswordReset($user));
            }
        );

        // If the password was successfully reset, we will redirect the user back to
        // the application's home page. If there is an error we can redirect them
        // back to the input. Notice that we use the validated form data.
        if ($status === Password::PASSWORD_RESET) {
            return view('auth.reset-success');
        }

        return back()
            ->withInput($request->only('email'))
            ->withErrors(['email' => __($status)]);
    }
}
