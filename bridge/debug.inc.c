/*
 * Shared debug logging for all bridge shards.
 *
 * Included first from v_bridge.c so every subsequent .inc.c shard can call
 * vphp_bridge_debug_enabled() and vphp_bridge_debug_log() without duplicating
 * the getenv / fopen / fprintf boilerplate.
 *
 * Tag conventions (preserved from per-shard originals):
 *   "vphp-bridge-debug"  — call and object shards
 *   "vphp-value-debug"   — values shard
 *   "vphp-runtime-debug" — runtime shard
 */

static int vphp_bridge_debug_enabled(void) {
  const char *path = getenv("VSLIM_CLI_DEBUG_FILE");
  if (path != NULL && path[0] != '\0') {
    return 2;
  }
  const char *flag = getenv("VSLIM_CLI_DEBUG");
  if (flag != NULL && flag[0] != '\0') {
    return 1;
  }
  return 0;
}

static void vphp_bridge_debug_log(const char *tag, const char *message) {
  int mode = vphp_bridge_debug_enabled();
  FILE *fp = NULL;
  if (mode == 0) {
    return;
  }
  if (mode == 2) {
    const char *path = getenv("VSLIM_CLI_DEBUG_FILE");
    fp = fopen(path, "ab");
    if (fp == NULL) {
      return;
    }
  } else {
    fp = stderr;
  }
  fprintf(fp, "[%s] %s\n", tag, message);
  fflush(fp);
  if (mode == 2 && fp != NULL) {
    fclose(fp);
  }
}

static void vphp_bridge_debug_log_zval(const char *tag, const char *prefix,
                                       zval *zv) {
  char debug_buf[512];
  int type = zv ? Z_TYPE_P(zv) : -1;
  if (zv == NULL) {
    snprintf(debug_buf, sizeof(debug_buf), "%s zval=NULL", prefix);
    vphp_bridge_debug_log(tag, debug_buf);
    return;
  }
  if (Z_REFCOUNTED_P(zv)) {
    if (Z_TYPE_P(zv) == IS_OBJECT) {
      zend_class_entry *ce = Z_OBJCE_P(zv);
      snprintf(debug_buf, sizeof(debug_buf),
               "%s zval=%p type=%d refcount=%u gc_flags=0x%x object=%p "
               "handlers=%p class=%s",
               prefix, (void *)zv, type, GC_REFCOUNT(Z_COUNTED_P(zv)),
               GC_FLAGS(Z_COUNTED_P(zv)), (void *)Z_OBJ_P(zv),
               Z_OBJ_P(zv) ? (void *)Z_OBJ_HT_P(zv) : NULL,
               (ce && ZSTR_VAL(ce->name)) ? ZSTR_VAL(ce->name) : "(null)");
      vphp_bridge_debug_log(tag, debug_buf);
      return;
    }
    snprintf(debug_buf, sizeof(debug_buf),
             "%s zval=%p type=%d refcount=%u gc_flags=0x%x", prefix,
             (void *)zv, type, GC_REFCOUNT(Z_COUNTED_P(zv)),
             GC_FLAGS(Z_COUNTED_P(zv)));
    vphp_bridge_debug_log(tag, debug_buf);
    return;
  }
  snprintf(debug_buf, sizeof(debug_buf), "%s zval=%p type=%d non_refcounted",
           prefix, (void *)zv, type);
  vphp_bridge_debug_log(tag, debug_buf);
}

static const char *vphp_debug_zval_class_name(zval *z) {
  zend_class_entry *ce = NULL;
  if (z == NULL || Z_TYPE_P(z) != IS_OBJECT) {
    return "(none)";
  }
  ce = Z_OBJCE_P(z);
  if (ce == NULL || ce->name == NULL) {
    return "(null)";
  }
  return ZSTR_VAL(ce->name);
}
