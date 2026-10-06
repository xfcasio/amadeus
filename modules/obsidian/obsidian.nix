# Obsidian Nix Export - generated 2026-10-06

{
  config = {
      app = {
        attachmentFolderPath = "assets";
        pdfExportSettings = {
          downscalePercent = 100;
          includeName = true;
          landscape = false;
          margin = "0";
          pageSize = "A4";
        };
        readableLineLength = false;
        vimMode = true;
      };
      appearance = {
        cssTheme = "deeper work";
        enabledCssSnippets = [
          "print"
          "code-font"
        ];
        interfaceFontFamily = "";
        monospaceFontFamily = "Calibri";
      };
      core-plugins = {
        audio-recorder = false;
        backlink = true;
        bases = true;
        bookmarks = true;
        canvas = true;
        command-palette = true;
        daily-notes = true;
        editor-status = true;
        file-explorer = true;
        file-recovery = true;
        footnotes = false;
        global-search = true;
        graph = true;
        markdown-importer = false;
        note-composer = true;
        outgoing-link = true;
        outline = true;
        page-preview = true;
        properties = false;
        publish = false;
        random-note = false;
        slash-command = false;
        slides = false;
        switcher = true;
        sync = true;
        tag-pane = true;
        templates = true;
        webviewer = false;
        word-count = true;
        workspaces = false;
        zk-prefixer = false;
      };
      graph = {
        centerStrength = 1;
        close = true;
        collapse-color-groups = true;
        collapse-display = false;
        collapse-filter = true;
        collapse-forces = true;
        colorGroups = [
          {
            color = {
              a = 1;
              rgb = 14701138;
            };
            query = "tag:#youtube_video  ";
          }
          {
            color = {
              a = 1;
              rgb = 14725458;
            };
            query = "";
          }
        ];
        hideUnresolved = false;
        lineSizeMultiplier = 1;
        linkDistance = 305;
        linkStrength = 0.901051727838592;
        nodeSizeMultiplier = 1;
        repelStrength = 5.93260356299635;
        scale = 0.11224832115554839;
        search = "";
        showArrow = false;
        showAttachments = false;
        showOrphans = true;
        showTags = false;
        textFadeMultiplier = 0;
      };
      hotkeys = {
        "better-export-pdf:export-current-file-to-pdf" = [
          {
            key = "E";
            modifiers = [
              "Mod"
              "Shift"
            ];
          }
        ];
        "calendar:show-calendar-view" = [
          {
            key = "D";
            modifiers = [
              "Mod"
              "Shift"
            ];
          }
        ];
        "large-language-models:open-LLM-widget-tab" = [
          {
            key = "A";
            modifiers = [
              "Mod"
              "Shift"
            ];
          }
        ];
        "nixsync:export-settings-as-nix" = [
          {
            key = "K";
            modifiers = [
              "Mod"
              "Meta"
            ];
          }
        ];
        "obsidian-kanban:create-new-kanban-board" = [
          {
            key = "B";
            modifiers = [
              "Mod"
              "Shift"
            ];
          }
        ];
      };
      workspace = { };
    };

  plugins = {
      calendar = {
        manifest = {
          author = "Liam Cain";
          authorUrl = "https://github.com/liamcain/";
          description = "Calendar view of your daily notes";
          id = "calendar";
          isDesktopOnly = false;
          minAppVersion = "0.9.11";
          name = "Calendar";
          version = "1.5.10";
        };
        settings = {
          localeOverride = "system-default";
          shouldConfirmBeforeCreate = true;
          showWeeklyNote = false;
          weekStart = "locale";
          weeklyNoteFolder = "";
          weeklyNoteFormat = "";
          weeklyNoteTemplate = "";
          wordsPerDot = 250;
        };
      };
      data-cards = {
        manifest = {
          author = "Sophokles187";
          authorUrl = "https://github.com/Sophokles187";
          description = "Transform Dataview query results into visually appealing, customizable card layouts.";
          fundingUrl = "https://ko-fi.com/sophokles";
          id = "data-cards";
          isDesktopOnly = false;
          minAppVersion = "0.15.0";
          name = "DataCards";
          version = "1.1.0";
        };
        settings = null;
      };
      dataview = {
        manifest = {
          author = "Michael Brenan <blacksmithgu@gmail.com>";
          authorUrl = "https://github.com/blacksmithgu";
          description = "Complex data views for the data-obsessed.";
          helpUrl = "https://blacksmithgu.github.io/obsidian-dataview/";
          id = "dataview";
          isDesktopOnly = false;
          minAppVersion = "0.13.11";
          name = "Dataview";
          version = "0.5.68";
        };
        settings = null;
      };
      nixsync = {
        manifest = {
          author = "rowmayne";
          authorUrl = "https://github.com/rowmayne";
          description = "Export and import vault settings and plugins as Nix.";
          id = "nixsync";
          isDesktopOnly = true;
          minAppVersion = "0.15.0";
          name = "Nixsync";
          version = "1.0.0";
        };
        settings = {
          exportFileName = "obsidian.nix";
          generateNixosFiles = true;
          includeAppConfig = true;
          includeAppearance = true;
          includeCorePlugins = true;
          includeGraph = true;
          includeHotkeys = true;
          includePluginSettings = true;
          includePlugins = true;
          includeWorkspace = true;
          nixosActivateFileName = "obsidian-activate.sh";
          openAfterExport = true;
          stripWorkspaceFields = true;
        };
      };
      obsidian-kanban = {
        manifest = {
          author = "mgmeyers";
          authorUrl = "https://github.com/mgmeyers/obsidian-kanban";
          description = "Create markdown-backed Kanban boards in Obsidian.";
          helpUrl = "https://publish.obsidian.md/kanban/Obsidian+Kanban+Plugin";
          id = "obsidian-kanban";
          isDesktopOnly = false;
          minAppVersion = "1.0.0";
          name = "Kanban";
          version = "2.0.51";
        };
        settings = {
          show-checkboxes = false;
        };
      };
      themed-discord-rpc = {
        manifest = {
          author = "Mouadhbendjedidi";
          authorUrl = "https://github.com/Mouadhbendjedidi";
          description = "A Customizable Discord RPC";
          id = "themed-discord-rpc";
          isDesktopOnly = true;
          minAppVersion = "0.15.0";
          name = "Themed Discord RPC";
          version = "1.2.1";
        };
        settings = {
          autoHideStatusBar = true;
          connectOnStart = true;
          customVaultName = "";
          privacyMode = false;
          showConnectionTimer = false;
          showCurrentFileName = false;
          showFileExtension = false;
          showFolderName = false;
          showPopups = true;
          showVaultName = true;
          themeStyle = "mocha";
          useLoadedTime = false;
        };
      };
      vimium = {
        manifest = {
          author = "Karsten Finderup Pedersen";
          description = "Interact with elements using keyboard shortcuts in the spirit of Vim";
          id = "vimium";
          isDesktopOnly = true;
          minAppVersion = "0.15.0";
          name = "Vimium";
          version = "1.0.0";
        };
        settings = null;
      };
    };
}