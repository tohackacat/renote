pub struct Config {
    pub home: std::path::PathBuf,
}

impl Config {
    pub fn new(home: std::path::PathBuf) -> Self {
        Self { home }
    }
    pub fn from_env() -> Result<Self, std::env::VarError> {
        use std::env::var;
        let home = var("RENOTE_HOME")
            .or_else(|_| {
                Ok(var("XDG_DATA_HOME")
                    .or_else(|_| var("LOCALAPPDATA"))
                    .or_else(|_| var("HOME"))?
                    + "/renote")
            })?
            .into();
        Ok(Self::new(home))
    }
    pub fn init(&self) -> Result<(), std::io::Error> {
        if !std::fs::exists(&self.home)? {
            std::fs::create_dir_all(&self.home)?;
        }
        Ok(())
    }
}
