use std::env;

fn main() {
    println!("环境变量检查:");
    println!("OPENAI_API_KEY: {:?}", env::var("OPENAI_API_KEY"));
    println!("OPENAI_BASE_URL: {:?}", env::var("OPENAI_BASE_URL"));
    println!("ANTHROPIC_API_KEY: {:?}", env::var("ANTHROPIC_API_KEY"));
    println!("ANTHROPIC_AUTH_TOKEN: {:?}", env::var("ANTHROPIC_AUTH_TOKEN"));
    println!("XAI_API_KEY: {:?}", env::var("XAI_API_KEY"));
}