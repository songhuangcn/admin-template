# text 模块开头的 key 可以直接做翻译文本
# t("text.创建") => 创建
# t("text.user.更新") => 更新
# 需要其他语言翻译时，直接用这些文本做 key

I18N_TEXT_MODULE_NAME = "text.".freeze

I18n.exception_handler = lambda do |exception, locale, key, options|
  if !exception.is_a?(I18n::MissingTranslation) || !key.starts_with?(I18N_TEXT_MODULE_NAME)
    raise exception
  end

  key.to_s.split(".").last
end
