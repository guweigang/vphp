module zend

#include <php.h>
#include "v_bridge.h"

// 这里现在不需要代码，作为一个空的聚合入口
// 或者存放 V 侧专用的底层结构
pub struct AsyncResult {
pub mut:
	handle thread []f64
}
