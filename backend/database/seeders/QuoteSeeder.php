<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Quote;
use App\Models\Category;

class QuoteSeeder extends Seeder
{
    public function run(): void
    {
        $categories = Category::all()->keyBy('slug');
        
        $quotes = [
            // Motivation (15 quotes)
            ['content' => 'The only way to do great work is to love what you do.', 'author' => 'Steve Jobs', 'category' => 'motivation'],
            ['content' => 'Believe you can and you\'re halfway there.', 'author' => 'Theodore Roosevelt', 'category' => 'motivation'],
            ['content' => 'Success is not final, failure is not fatal: it is the courage to continue that counts.', 'author' => 'Winston Churchill', 'category' => 'motivation'],
            ['content' => 'Don\'t watch the clock; do what it does. Keep going.', 'author' => 'Sam Levenson', 'category' => 'motivation'],
            ['content' => 'The future belongs to those who believe in the beauty of their dreams.', 'author' => 'Eleanor Roosevelt', 'category' => 'motivation'],
            ['content' => 'It does not matter how slowly you go as long as you do not stop.', 'author' => 'Confucius', 'category' => 'motivation'],
            ['content' => 'Everything you\'ve ever wanted is on the other side of fear.', 'author' => 'George Addair', 'category' => 'motivation'],
            ['content' => 'Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine.', 'author' => 'Roy T. Bennett', 'category' => 'motivation'],
            ['content' => 'I learned that courage was not the absence of fear, but the triumph over it.', 'author' => 'Nelson Mandela', 'category' => 'motivation'],
            ['content' => 'There is only one thing that makes a dream impossible to achieve: the fear of failure.', 'author' => 'Paulo Coelho', 'category' => 'motivation'],
            ['content' => 'It\'s not whether you get knocked down, it\'s whether you get up.', 'author' => 'Vince Lombardi', 'category' => 'motivation'],
            ['content' => 'Your limitation—it\'s only your imagination.', 'author' => 'Unknown', 'category' => 'motivation'],
            ['content' => 'Push yourself, because no one else is going to do it for you.', 'author' => 'Unknown', 'category' => 'motivation'],
            ['content' => 'Great things never come from comfort zones.', 'author' => 'Unknown', 'category' => 'motivation'],
            ['content' => 'Dream it. Wish it. Do it.', 'author' => 'Unknown', 'category' => 'motivation'],

            // Love (12 quotes)
            ['content' => 'The best thing to hold onto in life is each other.', 'author' => 'Audrey Hepburn', 'category' => 'love'],
            ['content' => 'Love is composed of a single soul inhabiting two bodies.', 'author' => 'Aristotle', 'category' => 'love'],
            ['content' => 'Where there is love there is life.', 'author' => 'Mahatma Gandhi', 'category' => 'love'],
            ['content' => 'You know you\'re in love when you can\'t fall asleep because reality is finally better than your dreams.', 'author' => 'Dr. Seuss', 'category' => 'love'],
            ['content' => 'Love is not about how many days, months, or years you have been together. Love is about how much you love each other every single day.', 'author' => 'Unknown', 'category' => 'love'],
            ['content' => 'Being deeply loved by someone gives you strength, while loving someone deeply gives you courage.', 'author' => 'Lao Tzu', 'category' => 'love'],
            ['content' => 'The greatest happiness of life is the conviction that we are loved.', 'author' => 'Victor Hugo', 'category' => 'love'],
            ['content' => 'Love recognizes no barriers. It jumps hurdles, leaps fences, penetrates walls to arrive at its destination full of hope.', 'author' => 'Maya Angelou', 'category' => 'love'],
            ['content' => 'To love and be loved is to feel the sun from both sides.', 'author' => 'David Viscott', 'category' => 'love'],
            ['content' => 'Love is when the other person\'s happiness is more important than your own.', 'author' => 'H. Jackson Brown Jr.', 'category' => 'love'],
            ['content' => 'The best and most beautiful things in this world cannot be seen or even heard, but must be felt with the heart.', 'author' => 'Helen Keller', 'category' => 'love'],
            ['content' => 'Love is friendship that has caught fire.', 'author' => 'Ann Landers', 'category' => 'love'],

            // Success (15 quotes)
            ['content' => 'Success is not the key to happiness. Happiness is the key to success.', 'author' => 'Albert Schweitzer', 'category' => 'success'],
            ['content' => 'The way to get started is to quit talking and begin doing.', 'author' => 'Walt Disney', 'category' => 'success'],
            ['content' => 'Don\'t be afraid to give up the good to go for the great.', 'author' => 'John D. Rockefeller', 'category' => 'success'],
            ['content' => 'I find that the harder I work, the more luck I seem to have.', 'author' => 'Thomas Jefferson', 'category' => 'success'],
            ['content' => 'Success usually comes to those who are too busy to be looking for it.', 'author' => 'Henry David Thoreau', 'category' => 'success'],
            ['content' => 'Opportunities don\'t happen. You create them.', 'author' => 'Chris Grosser', 'category' => 'success'],
            ['content' => 'Don\'t let yesterday take up too much of today.', 'author' => 'Will Rogers', 'category' => 'success'],
            ['content' => 'You learn more from failure than from success. Don\'t let it stop you. Failure builds character.', 'author' => 'Unknown', 'category' => 'success'],
            ['content' => 'If you are working on something that you really care about, you don\'t have to be pushed. The vision pulls you.', 'author' => 'Steve Jobs', 'category' => 'success'],
            ['content' => 'People who are crazy enough to think they can change the world, are the ones who do.', 'author' => 'Rob Siltanen', 'category' => 'success'],
            ['content' => 'Failure will never overtake me if my determination to succeed is strong enough.', 'author' => 'Og Mandino', 'category' => 'success'],
            ['content' => 'We may encounter many defeats but we must not be defeated.', 'author' => 'Maya Angelou', 'category' => 'success'],
            ['content' => 'Knowing is not enough; we must apply. Wishing is not enough; we must do.', 'author' => 'Johann Wolfgang Von Goethe', 'category' => 'success'],
            ['content' => 'Whether you think you can or think you can\'t, you\'re right.', 'author' => 'Henry Ford', 'category' => 'success'],
            ['content' => 'The only limit to our realization of tomorrow will be our doubts of today.', 'author' => 'Franklin D. Roosevelt', 'category' => 'success'],

            // Wisdom (13 quotes)
            ['content' => 'The only true wisdom is in knowing you know nothing.', 'author' => 'Socrates', 'category' => 'wisdom'],
            ['content' => 'The fool doth think he is wise, but the wise man knows himself to be a fool.', 'author' => 'William Shakespeare', 'category' => 'wisdom'],
            ['content' => 'Knowing yourself is the beginning of all wisdom.', 'author' => 'Aristotle', 'category' => 'wisdom'],
            ['content' => 'The journey of a thousand miles begins with one step.', 'author' => 'Lao Tzu', 'category' => 'wisdom'],
            ['content' => 'In the middle of difficulty lies opportunity.', 'author' => 'Albert Einstein', 'category' => 'wisdom'],
            ['content' => 'Turn your wounds into wisdom.', 'author' => 'Oprah Winfrey', 'category' => 'wisdom'],
            ['content' => 'The only way to do great work is to love what you do.', 'author' => 'Steve Jobs', 'category' => 'wisdom'],
            ['content' => 'Change your thoughts and you change your world.', 'author' => 'Norman Vincent Peale', 'category' => 'wisdom'],
            ['content' => 'The mind is everything. What you think you become.', 'author' => 'Buddha', 'category' => 'wisdom'],
            ['content' => 'Yesterday is history, tomorrow is a mystery, today is a gift of God, which is why we call it the present.', 'author' => 'Bil Keane', 'category' => 'wisdom'],
            ['content' => 'An unexamined life is not worth living.', 'author' => 'Socrates', 'category' => 'wisdom'],
            ['content' => 'The only impossible journey is the one you never begin.', 'author' => 'Tony Robbins', 'category' => 'wisdom'],
            ['content' => 'We cannot solve problems with the kind of thinking we employed when we came up with them.', 'author' => 'Albert Einstein', 'category' => 'wisdom'],

            // Life (13 quotes)
            ['content' => 'Life is what happens when you\'re busy making other plans.', 'author' => 'John Lennon', 'category' => 'life'],
            ['content' => 'Get busy living or get busy dying.', 'author' => 'Stephen King', 'category' => 'life'],
            ['content' => 'You only live once, but if you do it right, once is enough.', 'author' => 'Mae West', 'category' => 'life'],
            ['content' => 'In the end, it\'s not the years in your life that count. It\'s the life in your years.', 'author' => 'Abraham Lincoln', 'category' => 'life'],
            ['content' => 'Life is either a daring adventure or nothing at all.', 'author' => 'Helen Keller', 'category' => 'life'],
            ['content' => 'The purpose of our lives is to be happy.', 'author' => 'Dalai Lama', 'category' => 'life'],
            ['content' => 'Life is really simple, but we insist on making it complicated.', 'author' => 'Confucius', 'category' => 'life'],
            ['content' => 'May you live every day of your life.', 'author' => 'Jonathan Swift', 'category' => 'life'],
            ['content' => 'Life itself is the most wonderful fairy tale.', 'author' => 'Hans Christian Andersen', 'category' => 'life'],
            ['content' => 'Do not let making a living prevent you from making a life.', 'author' => 'John Wooden', 'category' => 'life'],
            ['content' => 'Life is not a problem to be solved, but a reality to be experienced.', 'author' => 'Soren Kierkegaard', 'category' => 'life'],
            ['content' => 'The unexamined life is not worth living.', 'author' => 'Socrates', 'category' => 'life'],
            ['content' => 'Not how long, but how well you have lived is the main thing.', 'author' => 'Seneca', 'category' => 'life'],

            // Happiness (12 quotes)
            ['content' => 'Happiness is not something ready made. It comes from your own actions.', 'author' => 'Dalai Lama', 'category' => 'happiness'],
            ['content' => 'The most important thing is to enjoy your life—to be happy—it\'s all that matters.', 'author' => 'Audrey Hepburn', 'category' => 'happiness'],
            ['content' => 'Happiness is when what you think, what you say, and what you do are in harmony.', 'author' => 'Mahatma Gandhi', 'category' => 'happiness'],
            ['content' => 'For every minute you are angry you lose sixty seconds of happiness.', 'author' => 'Ralph Waldo Emerson', 'category' => 'happiness'],
            ['content' => 'Happiness is a warm puppy.', 'author' => 'Charles M. Schulz', 'category' => 'happiness'],
            ['content' => 'Count your age by friends, not years. Count your life by smiles, not tears.', 'author' => 'John Lennon', 'category' => 'happiness'],
            ['content' => 'Happiness depends upon ourselves.', 'author' => 'Aristotle', 'category' => 'happiness'],
            ['content' => 'The secret of happiness is not in doing what one likes, but in liking what one does.', 'author' => 'James M. Barrie', 'category' => 'happiness'],
            ['content' => 'Happiness is not by chance, but by choice.', 'author' => 'Jim Rohn', 'category' => 'happiness'],
            ['content' => 'The greatest happiness you can have is knowing that you do not necessarily require happiness.', 'author' => 'William Saroyan', 'category' => 'happiness'],
            ['content' => 'Be happy for this moment. This moment is your life.', 'author' => 'Omar Khayyam', 'category' => 'happiness'],
            ['content' => 'Happiness is the only thing that multiplies when you share it.', 'author' => 'Albert Schweitzer', 'category' => 'happiness'],

            // Inspiration (10 quotes)
            ['content' => 'The only impossible journey is the one you never begin.', 'author' => 'Tony Robbins', 'category' => 'inspiration'],
            ['content' => 'What lies behind us and what lies before us are tiny matters compared to what lies within us.', 'author' => 'Ralph Waldo Emerson', 'category' => 'inspiration'],
            ['content' => 'You are never too old to set another goal or to dream a new dream.', 'author' => 'C.S. Lewis', 'category' => 'inspiration'],
            ['content' => 'Try to be a rainbow in someone else\'s cloud.', 'author' => 'Maya Angelou', 'category' => 'inspiration'],
            ['content' => 'Do what you can, with what you have, where you are.', 'author' => 'Theodore Roosevelt', 'category' => 'inspiration'],
            ['content' => 'If you can dream it, you can achieve it.', 'author' => 'Zig Ziglar', 'category' => 'inspiration'],
            ['content' => 'A champion is defined not by their wins but by how they can recover when they fall.', 'author' => 'Serena Williams', 'category' => 'inspiration'],
            ['content' => 'You must be the change you wish to see in the world.', 'author' => 'Mahatma Gandhi', 'category' => 'inspiration'],
            ['content' => 'Spread love everywhere you go.', 'author' => 'Mother Teresa', 'category' => 'inspiration'],
            ['content' => 'When you have a dream, you\'ve got to grab it and never let go.', 'author' => 'Carol Burnett', 'category' => 'inspiration'],

            // Friendship (10 quotes)
            ['content' => 'A friend is someone who knows all about you and still loves you.', 'author' => 'Elbert Hubbard', 'category' => 'friendship'],
            ['content' => 'Friendship is born at that moment when one person says to another: What! You too? I thought I was the only one.', 'author' => 'C.S. Lewis', 'category' => 'friendship'],
            ['content' => 'A real friend is one who walks in when the rest of the world walks out.', 'author' => 'Walter Winchell', 'category' => 'friendship'],
            ['content' => 'True friendship comes when the silence between two people is comfortable.', 'author' => 'David Tyson', 'category' => 'friendship'],
            ['content' => 'There is nothing on this earth more to be prized than true friendship.', 'author' => 'Thomas Aquinas', 'category' => 'friendship'],
            ['content' => 'A friend is one that knows you as you are, understands where you have been, accepts what you have become, and still, gently allows you to grow.', 'author' => 'William Shakespeare', 'category' => 'friendship'],
            ['content' => 'The only way to have a friend is to be one.', 'author' => 'Ralph Waldo Emerson', 'category' => 'friendship'],
            ['content' => 'Friends are the family you choose.', 'author' => 'Jess C. Scott', 'category' => 'friendship'],
            ['content' => 'A true friend never gets in your way unless you happen to be going down.', 'author' => 'Arnold H. Glasow', 'category' => 'friendship'],
            ['content' => 'Friendship is the only cement that will ever hold the world together.', 'author' => 'Woodrow Wilson', 'category' => 'friendship'],
        ];

        // ... existing hardcoded quotes logic ...
        foreach ($quotes as $quoteData) {
            $category = $categories[$quoteData['category']];
            Quote::firstOrCreate([
                'content' => $quoteData['content']
            ], [
                'author' => $quoteData['author'],
                'category_id' => $category->id,
            ]);
        }

        // Load additional quotes from JSON
        $jsonPath = database_path('data/quotes.json');
        if (file_exists($jsonPath)) {
            $json = json_decode(file_get_contents($jsonPath), true);
            $newQuotes = [];
            $limit = 900;
            $count = 0;
            
            // Get existing quote contents to avoid duplicates
            $existingContents = Quote::pluck('content')->toArray();
            $existingContents = array_flip($existingContents); // For fast lookup

            $keywordMapping = [
                 'love' => ['love', 'heart', 'affection', 'romance', 'soul'],
                 'success' => ['success', 'work', 'win', 'goal', 'achievement', 'money', 'business', 'action', 'fail'],
                 'motivation' => ['believe', 'courage', 'dream', 'possible', 'try', 'hard', 'strong', 'push'],
                 'wisdom' => ['wisdom', 'know', 'think', 'mind', 'knowledge', 'learn', 'truth', 'smart'],
                 'happiness' => ['happy', 'joy', 'smile', 'glad', 'fun'],
                 'friendship' => ['friend'],
                 'life' => ['life', 'live', 'world', 'time', 'day', 'year', 'moment'],
            ];

            // Shuffle json to get variety if we only pick 900
            shuffle($json);

            foreach ($json as $item) {
                if ($count >= $limit) break;

                // Skip if content represents an empty string or something invalid
                if (empty($item['body'])) continue;

                $content = $item['body'];
                $author = $item['by'] ?? 'Unknown';

                // Skip if already exists
                if (isset($existingContents[$content])) {
                    continue;
                }

                // Determine category
                $targetSlug = 'inspiration'; // Default
                $found = false;

                $lowerContent = strtolower($content);
                foreach ($keywordMapping as $slug => $keywords) {
                    foreach ($keywords as $word) {
                        if (str_contains($lowerContent, $word)) {
                            $targetSlug = $slug;
                            $found = true;
                            break 2;
                        }
                    }
                }
                
                if (isset($categories[$targetSlug])) {
                     // Check for duplication in the current batch or DB? 
                     // For speed, we just add to batch. DB unique constraint might fail if content is unique.
                     // Assuming 'content' is not unique text column in DB migration, or we don't care about some dupes for now.
                     // Safe approach: check if content already exists in the $quotes array we just added? 
                     // Or just insert.
                     
                     $newQuotes[] = [
                        'id' => (string) \Illuminate\Support\Str::uuid(),
                        'content' => $content,
                        'author' => $author,
                        'category_id' => $categories[$targetSlug]->id,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ];
                    $count++;
                }
            }

            if (!empty($newQuotes)) {
                // Chunk insert
                foreach (array_chunk($newQuotes, 100) as $chunk) {
                    Quote::insert($chunk);
                }
                $this->command->info("Added {$count} extra quotes from JSON file.");
            }
        }
    }
}
