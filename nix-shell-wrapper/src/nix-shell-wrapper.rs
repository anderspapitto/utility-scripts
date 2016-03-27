// This allows running
//   nix-shell-wrapper /path/to/some/shell.drv foo bar baz
// instead of
//   nix-shell /path/to/some/shell.drv --command "foo bar baz"
// which I wanted because if "bar" contains whitespace, getting
// all the escaping right is kind of annoying.
//

use std::env;
use std::process::Command;

fn shitty_escape(s : &str) -> String {
    "'".to_string() + s + "'"
}

fn build_shittily_escaped_command(args: &[String]) -> String {
    args.iter().fold("".to_string(), |a,b| a + " " + &shitty_escape(b))
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let ref drv = args[1];
    let ref rest = args[2..];

    Command::new("nix-shell")
        .arg(drv)
        .arg("--run")
        .arg(build_shittily_escaped_command(rest))
        .status()
        .unwrap_or_else(|e| { panic!("failed to execute process {}", e) });
}
