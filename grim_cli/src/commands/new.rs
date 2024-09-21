use std::fs;
use std::io::{self, Write};
use std::path::Path;
use chrono::Local;
use crate::constants::{DEFAULT_TEMPLATE_FILE_NAME, BOXES_DIRECTORY_NAME, TEMPLATE_DIRECTORY_NAME, MAX_BOX_NAME_LENGTH};

pub fn create_new_box() -> Result<(), Box<dyn std::error::Error>> {
    // Check if we are in the "boxes" directory
    let current_dir = std::env::current_dir()?;
    if current_dir.file_name().and_then(|name| name.to_str()) != Some(BOXES_DIRECTORY_NAME) {
        return Err(format!("Error: You must be in the '{}' directory to create a new box.", BOXES_DIRECTORY_NAME).into());
    }

    // Check if the __template folder exists
    let template_dir = current_dir.join(TEMPLATE_DIRECTORY_NAME);
    if !template_dir.is_dir() {
        return Err(format!("Error: The '{}' folder is missing in the current directory.", TEMPLATE_DIRECTORY_NAME).into());
    }

    // Use the default template file name
    let template_path = template_dir.join(DEFAULT_TEMPLATE_FILE_NAME);
    if !template_path.exists() {
        return Err(format!("Error: The template file '{}' is missing in the '{}' folder.", DEFAULT_TEMPLATE_FILE_NAME, TEMPLATE_DIRECTORY_NAME).into());
    }

    // Ask for the name
    print!("name: ");
    io::stdout().flush()?;
    let mut name = String::new();
    io::stdin().read_line(&mut name)?;
    let name = name.trim();

    // Validate box name length
    if name.len() > MAX_BOX_NAME_LENGTH {
        return Err(format!("Error: Box name cannot exceed {} characters.", MAX_BOX_NAME_LENGTH).into());
    }

    // Create a new folder with the name of the box
    let new_box_path = current_dir.join(name);
    fs::create_dir(&new_box_path)?;
    println!("Created new box folder: {}", new_box_path.display());

    // Create a copy of the template file with the correct naming
    let date = Local::now().format("%Y-%m-%d");
    let new_file_name = format!("{}-{}.md", date, name);
    let new_file_path = new_box_path.join(new_file_name);

    fs::copy(&template_path, &new_file_path)?;
    println!("Created new file: {}", new_file_path.display());

    Ok(())
}