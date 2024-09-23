pub mod commands;
pub mod constants;

use clap::{Command, FromArgMatches, Args};
use commands::{NewArgs, GgArgs};

pub fn run() -> Result<(), Box<dyn std::error::Error>> {
    let matches = Command::new("grim")
        .version("0.1.0")
        .author("Your Name")
        .about("A well-structured CLI app with multiple subcommands")
        .subcommand(
            Command::new("new")
                .about("Creates a new box")
                .args(NewArgs::augment_args(Command::new("new")).get_arguments())
        )
        .subcommand(
            Command::new("gg")
                .about("Read and execute a command from a file")
                .args(GgArgs::augment_args(Command::new("gg")).get_arguments())
        )
        .get_matches();

    match matches.subcommand() {
        Some(("new", sub_matches)) => {
            let args = NewArgs::from_arg_matches(sub_matches)?;
            commands::new::create_new_box(&args)?;
        }
        Some(("gg", sub_matches)) => {
            let args = GgArgs::from_arg_matches(sub_matches)?;
            commands::gg::run(&args)?;
        }
        _ => {
            println!("No subcommand was used. Use --help for usage information.");
        }
    }

    Ok(())
}