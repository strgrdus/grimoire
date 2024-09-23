use std::fs::{self, File};
use std::io::{self, BufRead, Write};
use std::path::Path;
use std::process::Command;

use anyhow::Result;
use clap::Parser;
use regex::Regex;

#[derive(Parser)]
pub struct GgArgs {
    /// The line number to read the command from
    line: usize,
    /// Optional: Specify a file to read the command from (overrides automatic detection)
    #[clap(long, short)]
    file: Option<String>,
}

fn find_markdown_file() -> Option<String> {
    let current_dir = std::env::current_dir().ok()?;
    let entries = fs::read_dir(current_dir).ok()?;
    let md_regex = Regex::new(r"(?i)\.md$").ok()?;

    entries
        .filter_map(|entry| {
            let entry = entry.ok()?;
            let path = entry.path();
            if path.is_file() && md_regex.is_match(&path.to_string_lossy()) {
                Some(path.to_string_lossy().into_owned())
            } else {
                None
            }
        })
        .next()
}

pub fn run(args: &GgArgs) -> Result<()> {
    let file_path = match &args.file {
        Some(file) => file.clone(),
        None => find_markdown_file().ok_or_else(|| anyhow::anyhow!("No markdown file found in the current directory"))?,
    };

    println!("Using file: {}", file_path);

    let file = File::open(&file_path)?;
    let reader = io::BufReader::new(file);

    let command = reader
        .lines()
        .nth(args.line - 1)
        .ok_or_else(|| anyhow::anyhow!("Line {} not found in file", args.line))?
        .map_err(|e| anyhow::anyhow!("Error reading line: {}", e))?;

    println!("Command to execute: {}", command);
    print!("Do you want to execute this command? (y/n): ");
    io::stdout().flush()?;

    let mut input = String::new();
    io::stdin().read_line(&mut input)?;

    if input.trim().to_lowercase() == "y" {
        let output = Command::new("sh")
            .arg("-c")
            .arg(&command)
            .output()?;

        io::stdout().write_all(&output.stdout)?;
        io::stderr().write_all(&output.stderr)?;
    } else {
        println!("Command execution cancelled.");
    }

    Ok(())
}