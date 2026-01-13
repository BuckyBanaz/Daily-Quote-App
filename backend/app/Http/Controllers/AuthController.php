<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use Illuminate\Support\Facades\Hash;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use OpenApi\Annotations as OA;

/**
 * Auth Controller
 */
class AuthController extends Controller
{

    public function register(Request $request) {
        $fields = $request->validate([
            'name' => 'required|string',
            'email' => 'required|string|email|unique:users,email',
            'password' => 'required|string|min:6',
            'password_confirmation' => 'sometimes|same:password',
            'fcm_token' => 'nullable|string'
        ]);

        $user = User::create([
            'name' => $fields['name'],
            'email' => $fields['email'],
            'password' => bcrypt($fields['password']),
            'fcm_token' => $fields['fcm_token'] ?? null,
        ]);

        $token = $user->createToken('myapptoken')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Account created successfully! You can now login.',
            'user' => $user,
            'token' => $token
        ], 201);
    }


    public function login(Request $request) {
        $fields = $request->validate([
            'email' => 'required|string|email',
            'password' => 'required|string'
        ]);

        // Check email
        $user = User::where('email', $fields['email'])->first();

        // Check password
        if(!$user || !Hash::check($fields['password'], $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid email or password. Please check your credentials and try again.'
            ], 401);
        }
        
        // Update fcm token if passed in login
        if($request->has('fcm_token')){
             $user->update(['fcm_token' => $request->fcm_token]);
        }

        $token = $user->createToken('myapptoken')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Login successful! Welcome back.',
            'user' => $user,
            'token' => $token
        ], 200);
    }
    
    public function logout(Request $request) {
        auth()->user()->tokens()->delete();
        return response()->json([
            'success' => true,
            'message' => 'You have been logged out successfully.'
        ]);
    }

    // PUT /api/user/profile
    public function updateProfile(Request $request) {
        $user = auth()->user();
        
        $validated = $request->validate([
            'name' => 'sometimes|string|max:255',
            'email' => 'sometimes|email|unique:users,email,' . $user->id,
            'password' => 'sometimes|string|min:6|confirmed',
            'fcm_token' => 'nullable|string',
        ]);

        if (isset($validated['password'])) {
            $validated['password'] = bcrypt($validated['password']);
        }

        $user->update($validated);

        return response()->json([
            'message' => 'Profile updated successfully',
            'user' => $user
        ]);
    }

    public function getProfile(Request $request) {
        return response()->json([
            'success' => true,
            'user' => $request->user()->loadCount('favorites')
        ]);
    }
}
