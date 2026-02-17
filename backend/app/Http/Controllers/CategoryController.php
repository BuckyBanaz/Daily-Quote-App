<?php

namespace App\Http\Controllers;

use App\Models\Category;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    // GET /api/categories
    public function index()
    {
        $categories = Category::withCount('quotes')->get();
        return response()->json($categories);
    }

    // POST /api/categories
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'slug' => 'required|string|unique:categories,slug',
            'icon' => 'nullable|string',
            'color' => 'nullable|string',
        ]);

        $category = Category::create($validated);
        return response()->json($category, 201);
    }

    // GET /api/categories/{id}
    public function show(Category $category)
    {
        $category->load('quotes');
        return response()->json($category);
    }

    // PUT/PATCH /api/categories/{id}
    public function update(Request $request, Category $category)
    {
        $validated = $request->validate([
            'name' => 'sometimes|string|max:255',
            'slug' => 'sometimes|string|unique:categories,slug,' . $category->id,
            'icon' => 'nullable|string',
            'color' => 'nullable|string',
        ]);

        $category->update($validated);
        return response()->json($category);
    }

    // DELETE /api/categories/{id}
    public function destroy(Category $category)
    {
        $category->delete();
        return response()->json(['message' => 'Category deleted successfully']);
    }
}
