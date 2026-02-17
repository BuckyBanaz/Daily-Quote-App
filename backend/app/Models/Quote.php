<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Concerns\HasUuids;

class Quote extends Model
{
    use HasUuids;

    protected $fillable = ['content', 'author', 'category_id'];

    protected $appends = ['likes_count', 'is_liked', 'is_favorited'];

    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function likedBy()
    {
        return $this->belongsToMany(User::class, 'quote_likes')->withTimestamps();
    }

    public function favoritedBy()
    {
        return $this->belongsToMany(User::class, 'user_favorites')->withTimestamps();
    }

    public function getLikesCountAttribute()
    {
        return $this->likedBy()->count();
    }

    public function getIsLikedAttribute()
    {
        if (!auth()->check()) {
            return false;
        }
        return $this->likedBy()->where('user_id', auth()->id())->exists();
    }

    public function getIsFavoritedAttribute()
    {
        if (!auth()->check()) {
            return false;
        }
        return $this->favoritedBy()->where('user_id', auth()->id())->exists();
    }
}
