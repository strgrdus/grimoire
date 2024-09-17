use clap::{Command, ArgMatches};

fn main() {
    let matches = Command::new("grim_cli")
        .version("0.1.0")
        .author("Your Name")
        .about("A well-structured CLI app with multiple subcommands")
        .subcommand(
            Command::new("new")
                .about("Creates a new item")
        )
        .get_matches();

    match matches.subcommand() {
        Some(("new", _)) => {
            println!("hello world");
        }
        _ => {
            println!("No subcommand was used. Use --help for usage information.");
        }
    }
}
