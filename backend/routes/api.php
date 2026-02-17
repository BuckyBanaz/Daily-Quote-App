<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\AuthController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\QuoteController;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/forgot-password', [App\Http\Controllers\PasswordResetController::class, 'sendResetLink']);

// Public routes
Route::get('/categories', [CategoryController::class, 'index']);
Route::get('/categories/{category}', [CategoryController::class, 'show']);
Route::get('/quotes', [QuoteController::class, 'index']);
Route::get('/quotes/random', [QuoteController::class, 'random']);

Route::group(['middleware' => ['auth:sanctum']], function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', [AuthController::class, 'getProfile']);
    Route::put('/user/profile', [AuthController::class, 'updateProfile']);
    
    // Protected routes for categories
    Route::post('/categories', [CategoryController::class, 'store']);
    Route::put('/categories/{category}', [CategoryController::class, 'update']);
    Route::delete('/categories/{category}', [CategoryController::class, 'destroy']);
    
    // Protected routes for quotes
    // IMPORTANT: Specific routes must come before dynamic routes
    Route::get('/quotes/favorites', [QuoteController::class, 'favoritedQuotes']);
    Route::get('/quotes/liked', [QuoteController::class, 'likedQuotes']);
    
    Route::post('/quotes', [QuoteController::class, 'store']);
    Route::put('/quotes/{quote}', [QuoteController::class, 'update']);
    Route::delete('/quotes/{quote}', [QuoteController::class, 'destroy']);
    
    // Like/Unlike routes
    Route::post('/quotes/{quote}/like', [QuoteController::class, 'like']);
    Route::delete('/quotes/{quote}/unlike', [QuoteController::class, 'unlike']);
    
    // Favorite routes
    Route::post('/quotes/{quote}/favorite', [QuoteController::class, 'favorite']);
    Route::delete('/quotes/{quote}/unfavorite', [QuoteController::class, 'unfavorite']);
});

// Move show to the end to avoid greedy matching
Route::get('/quotes/{quote}', [QuoteController::class, 'show']);
