fn has_api_key(key: &str) -> bool {
    std::env::var(key)
        .ok()
        .filter(|value| !value.is_empty())
        .is_some()
}

fn main() {
    println!("has_api_key(\"OPENAI_API_KEY\"): {}", has_api_key("OPENAI_API_KEY"));
    println!("has_api_key(\"XAI_API_KEY\"): {}", has_api_key("XAI_API_KEY"));
    println!("has_api_key(\"ANTHROPIC_API_KEY\"): {}", has_api_key("ANTHROPIC_API_KEY"));

    // 测试空字符串
    std::env::set_var("TEST_EMPTY", "");
    println!("has_api_key(\"TEST_EMPTY\"): {}", has_api_key("TEST_EMPTY"));

    // 测试非空字符串
    std::env::set_var("TEST_NOT_EMPTY", "value");
    println!("has_api_key(\"TEST_NOT_EMPTY\"): {}", has_api_key("TEST_NOT_EMPTY"));
}