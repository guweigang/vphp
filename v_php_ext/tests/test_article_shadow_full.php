<?php

echo "--- VPHP Shadow Architecture Full Test ---\n\n";

// 1. 验证常量 (Immutable)
echo "Checking Constants:\n";
assert(Article::MAX_TITLE_LEN === 1024);
assert(Article::NAME === 'Samantha Black');
echo "✅ Constants are correct: " . Article::NAME . " (Max: " . Article::MAX_TITLE_LEN . ")\n\n";

// 2. 验证初始静态状态
echo "Initial Static Property:\n";
echo "Article::\$total_count = " . Article::$total_count . "\n";
assert(Article::$total_count === 0);
echo "✅ Initial state is 0\n\n";

// 3. 实例化 Article (触发 V 侧 total_count++)
echo "Creating 3 Articles in PHP...\n";
$a1 = new Article("First Post", 1);
$a2 = new Article("Second Post", 2);
$a3 = new Article("Third Post", 3);

// 此时 V 的 init() 会运行 3 次
echo "Current Article::\$total_count = " . Article::$total_count . "\n";
assert(Article::$total_count === 3);
echo "✅ State synchronized from V to PHP!\n\n";

// 4. 在 PHP 侧手动修改，验证 V 侧下次是否生效
echo "Modifying total_count in PHP to 100...\n";
Article::$total_count = 100;
$a4 = new Article("Fourth Post", 4);
echo "After creating one more, total_count = " . Article::$total_count . "\n";
assert(Article::$total_count === 101);
echo "✅ Bidirectional synchronization achieved!\n\n";

// 5. 调用 Save 触发常量检查逻辑
echo "Calling save() to trigger V logic:\n";
$a4->save(); // 应该正常保存

echo "\n--- ALL TESTS PASSED! ---\n";
