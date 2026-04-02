use std::env;

fn main() {
    let model = "qwen3.5-122b-a10b";
    
    println!("检测提供商:");
    println!("模型: {}", model);
    println!("OPENAI_API_KEY: {:?}", env::var("OPENAI_API_KEY"));
    println!("XAI_API_KEY: {:?}", env::var("XAI_API_KEY"));
    println!("ANTHROPIC_API_KEY: {:?}", env::var("ANTHROPIC_API_KEY"));
    
    // 模拟 detect_provider_kind 的逻辑
    let provider = if env::var("OPENAI_API_KEY")
        .ok()
        .filter(|value| !value.is_empty())
        .is_some()
    {
        "OpenAi"
    } else if env::var("XAI_API_KEY")
        .ok()
        .filter(|value| !value.is_empty())
        .is_some()
    {
        "Xai"
    } else {
        "ClawApi"
    };
    
    println!("检测到的提供商: {}", provider);
}