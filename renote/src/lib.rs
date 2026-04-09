pub struct Config {
    pub home: std::path::PathBuf,
    pub editor: String,
}

impl Config {
    pub fn new(home: std::path::PathBuf, editor: String) -> Self {
        Self { home, editor }
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
        let editor =
            var("RENOTE_EDITOR").or_else(|_| Ok(var("EDITOR").or_else(|_| var("VISUAL")))?)?;
        Ok(Self::new(home, editor))
    }

    pub fn init(&self) -> Result<(), std::io::Error> {
        if !std::fs::exists(&self.home)? {
            std::fs::create_dir_all(&self.home)?;
        }
        Ok(())
    }
}

pub struct Note {
    id: std::path::PathBuf,
    pub content: String,
}

impl Note {
    pub fn new(id: std::path::PathBuf, content: String) -> Self {
        Self { id, content }
    }
    pub fn title(&self) -> &str {
        self.id
            .file_prefix()
            .unwrap_or_default()
            .to_str()
            .unwrap_or_default()
    }
}
