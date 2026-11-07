# Core installer engine
# Usage: just install <component> [variant]
install component variant="N/A":
    @case "{{component}}" in \
        "PS1") \
            echo "Starting PS1 Prompt installation..."; \
            chmod +x ./PS1.sh; \
            ./PS1.sh {{variant}}; \
            ;; \
        "tiling") \
            echo "Launching tiling window manager script..."; \
            chmod +x ./install_tiling.sh; \
            ./install_tiling.sh {{variant}}; \
            ;; \
        *) \
            echo "Error: Unknown component '{{component}}'."; \
            exit 1; \
            ;; \
    esac

# Core uninstaller engine
uninstall component variant="N/A":
    @case "{{component}}" in \
        "PS1") \
            sed -i '/# --- CUSTOM GIT PROMPT CONFIG ---/,/# --- END CUSTOM GIT PROMPT ---/d' ~/.bashrc; \
            echo "PS1 prompt removed."; \
            ;; \
        "tiling") \
            if [ "{{variant}}" = "regolith" ]; then \
                sudo apt purge -y regolith-desktop regolith-session-flashback; \
                sudo add-apt-repository --remove -y ppa:regolith-linux/release; \
            else \
                sudo apt purge -y i3 rofi feh i3status; \
            fi; \
            sudo apt autoremove -y; \
            echo "Tiling environment purged."; \
            ;; \
        *) \
            echo "Error: Unknown component '{{component}}'."; \
            exit 1; \
            ;; \
    esac
