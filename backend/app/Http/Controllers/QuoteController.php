<?php

namespace App\Http\Controllers;

use App\Models\Quote;
use Illuminate\Http\Request;

class QuoteController extends Controller
{
    // GET /api/quotes
    public function index(Request $request)
    {
        $query = Quote::with('category');
        
        // Filter by category
        if ($request->has('category_id')) {
            $query->where('category_id', $request->category_id);
        }
        
        $quotes = $query->latest()->paginate(20);
        return response()->json($quotes, 200, [], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    }

    // POST /api/quotes
    public function store(Request $request)
    {
        $validated = $request->validate([
            'content' => 'required|string',
            'author' => 'required|string|max:255',
            'category_id' => 'required|uuid|exists:categories,id',
        ]);

        $quote = Quote::create($validated);
        $quote->load('category');
        return response()->json($quote, 201);
    }

    // GET /api/quotes/{id}
    public function show(Quote $quote)
    {
        $quote->load('category');
        return response()->json($quote);
    }

    // PUT/PATCH /api/quotes/{id}
    public function update(Request $request, Quote $quote)
    {
        $validated = $request->validate([
            'content' => 'sometimes|string',
            'author' => 'sometimes|string|max:255',
            'category_id' => 'sometimes|uuid|exists:categories,id',
        ]);

        $quote->update($validated);
        $quote->load('category');
        return response()->json($quote);
    }

    // DELETE /api/quotes/{id}
    public function destroy(Quote $quote)
    {
        $quote->delete();
        return response()->json(['message' => 'Quote deleted successfully']);
    }
    
    // GET /api/quotes/random
    public function random(Request $request)
    {
        $query = Quote::with('category');
        
        // Filter by category if provided
        if ($request->has('category_id')) {
            $query->where('category_id', $request->category_id);
        }
        
        $quote = $query->inRandomOrder()->first();
        return response()->json($quote, 200, [], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    }

    // POST /api/quotes/{id}/like
    public function like(Quote $quote)
    {
        $user = auth()->user();
        
        // Check if already liked
        if ($quote->likedBy()->where('user_id', $user->id)->exists()) {
            return response()->json(['message' => 'Already liked'], 400);
        }
        
        $quote->likedBy()->attach($user->id);
        
        // Reload to get fresh data
        $quote->load('category');
        
        return response()->json([
            'message' => 'Quote liked successfully',
            'quote' => $quote
        ]);
    }

    // DELETE /api/quotes/{id}/unlike
    public function unlike(Quote $quote)
    {
        $user = auth()->user();
        
        $quote->likedBy()->detach($user->id);
        
        // Reload to get fresh data
        $quote->load('category');
        
        return response()->json([
            'message' => 'Quote unliked successfully',
            'quote' => $quote
        ]);
    }

    // GET /api/quotes/liked
    public function likedQuotes(Request $request)
    {
        $user = auth()->user();
        $query = Quote::with('category')
            ->whereHas('likedBy', function($q) use ($user) {
                $q->where('user_id', $user->id);
            });
        
        // Filter by category if provided
        if ($request->has('category_id')) {
            $query->where('category_id', $request->category_id);
        }
        
        $quotes = $query->latest()->paginate(20);
            
        return response()->json($quotes, 200, [], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    }

    /**
     * @OA\Post(
     *     path="/api/quotes/{id}/favorite",
     *     summary="Add quote to favorites",
     *     tags={"Quotes"},
     *     security={{"sanctum":{}}},
     *     @OA\Parameter(
     *         name="id",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="string")
     *     ),
     *     @OA\Response(response=200, description="Quote added to favorites"),
     *     @OA\Response(response=401, description="Unauthenticated")
     * )
     */
    public function favorite(Quote $quote)
    {
        $user = auth()->user();
        
        if ($quote->favoritedBy()->where('user_id', $user->id)->exists()) {
            return response()->json(['message' => 'Already in favorites'], 400);
        }
        
        $quote->favoritedBy()->attach($user->id);
        $quote->load('category');
        
        return response()->json([
            'message' => 'Quote added to favorites',
            'quote' => $quote
        ]);
    }

    /**
     * @OA\Delete(
     *     path="/api/quotes/{id}/unfavorite",
     *     summary="Remove quote from favorites",
     *     tags={"Quotes"},
     *     security={{"sanctum":{}}},
     *     @OA\Parameter(
     *         name="id",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="string")
     *     ),
     *     @OA\Response(response=200, description="Quote removed from favorites"),
     *     @OA\Response(response=401, description="Unauthenticated")
     * )
     */
    public function unfavorite(Quote $quote)
    {
        $user = auth()->user();
        $quote->favoritedBy()->detach($user->id);
        $quote->load('category');
        
        return response()->json([
            'message' => 'Quote removed from favorites',
            'quote' => $quote
        ]);
    }

    /**
     * @OA\Get(
     *     path="/api/quotes/favorites",
     *     summary="Get user's favorited quotes",
     *     tags={"Quotes"},
     *     security={{"sanctum":{}}},
     *     @OA\Parameter(
     *         name="category_id",
     *         in="query",
     *         required=false,
     *         @OA\Schema(type="string")
     *     ),
     *     @OA\Response(response=200, description="List of favorited quotes"),
     *     @OA\Response(response=401, description="Unauthenticated")
     * )
     */
    public function favoritedQuotes(Request $request)
    {
        $user = auth()->user();
        $query = Quote::with('category')
            ->whereHas('favoritedBy', function($q) use ($user) {
                $q->where('user_id', $user->id);
            });
        
        if ($request->has('category_id') && $request->category_id !== 'all') {
            $query->where('category_id', $request->category_id);
        }
        
        $quotes = $query->latest()->paginate(20);
        return response()->json($quotes, 200, [], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    }
}
