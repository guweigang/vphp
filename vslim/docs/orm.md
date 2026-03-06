# VSlim ORM Integration

`VSlim` 不内置 ORM。推荐直接复用成熟生态，`VSlim` 只做框架层与运行时桥接。

## Recommendation

- 优先走 PDO 兼容链路
- 生产项目建议二选一：
  - Doctrine ORM（企业级，模型与元数据能力强）
  - Eloquent（上手快，Laravel 生态友好）

## Runtime Prerequisites

- `vslim.so`
- `psr.so`（`VSlim\Container` 依赖 PSR 接口）
- 对应数据库驱动（如 `pdo_mysql` / `pdo_pgsql`）

## Doctrine ORM (minimal)

```bash
composer require doctrine/orm doctrine/dbal
```

```php
<?php

declare(strict_types=1);

use Doctrine\ORM\EntityManager;
use Doctrine\ORM\ORMSetup;

$config = ORMSetup::createAttributeMetadataConfiguration(
    paths: [__DIR__ . '/src/Entity'],
    isDevMode: true,
);

$conn = [
    'driver' => 'pdo_mysql',
    'host' => '127.0.0.1',
    'port' => 3306,
    'dbname' => 'app',
    'user' => 'root',
    'password' => 'root',
    'charset' => 'utf8mb4',
];

$em = EntityManager::create($conn, $config);

// register into VSlim container
$c = new VSlim\Container();
$c->set(EntityManager::class, $em);
```

## Eloquent (minimal)

```bash
composer require illuminate/database illuminate/events
```

```php
<?php

declare(strict_types=1);

use Illuminate\Database\Capsule\Manager as Capsule;

$capsule = new Capsule();
$capsule->addConnection([
    'driver' => 'mysql',
    'host' => '127.0.0.1',
    'port' => 3306,
    'database' => 'app',
    'username' => 'root',
    'password' => 'root',
    'charset' => 'utf8mb4',
    'collation' => 'utf8mb4_unicode_ci',
    'prefix' => '',
]);
$capsule->setAsGlobal();
$capsule->bootEloquent();

// register into VSlim container
$c = new VSlim\Container();
$c->set(Capsule::class, $capsule);
```

## Practical Notes

- 长连接与连接池建议交给数据库驱动/中间件，不在 `VSlim` 内重复实现
- 事务边界建议放在应用服务层，不放在路由闭包里
- ORM 只作为应用层依赖，不应与 `vhttpd` transport 耦合
