pub mod commands;

use clap::{Command, ArgMatches};

pub fn run() -> Result<(), Box<dyn std::error::Error>> {
    let matches = Command::new("grim")
        .version("0.1.0")
        .author("Your Name")
        .about("A well-structured CLI app with multiple subcommands")
        .subcommand(
            Command::new("new")
                .about("Creates a new box")
        )
        .get_matches();

    match matches.subcommand() {
        Some(("new", _)) => {
            commands::new::create_new_box()?;
        }
        _ => {
            println!("No subcommand was used. Use --help for usage information.");
        }
    }

    Ok(())
}