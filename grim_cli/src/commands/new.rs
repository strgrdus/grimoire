use std::fs;
use std::io::{self, Write};
use std::path::Path;
use std::env;
use chrono::Local;

pub fn create_new_box() -> Result<(), Box<dyn std::error::Error>> {
    // Check if we are in the "boxes" directory
    let current_dir = env::current_dir()?;
    if current_dir.file_name().and_then(|name| name.to_str()) != Some("boxes") {
        return Err("Error: You must be in the 'boxes' directory to create a new box.".into());
    }

    // Ask for the name
    print!("name: ");
    io::stdout().flush()?;
    let mut name = String::new();
    io::stdin().read_line(&mut name)?;
    let name = name.trim();

    // Create a new folder with the name of the box
    let new_box_path = current_dir.join(name);
    fs::create_dir(&new_box_path)?;
    println!("Created new box folder: {}", new_box_path.display());

    // Create a copy of the template file with the correct naming
    let template_path = current_dir.join("__template").join("0.00.md");
    let date = Local::now().format("%Y-%m-%d");
    let new_file_name = format!("{}-{}.md", date, name);
    let new_file_path = new_box_path.join(new_file_name);

    fs::copy(&template_path, &new_file_path)?;
    println!("Created new file: {}", new_file_path.display());

    Ok(())
}