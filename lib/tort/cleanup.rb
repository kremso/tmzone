module Tort
  module Cleanup
    def cleanup(text)
      text.gsub("\u00A0", " ").gsub("\n", "").strip if text
    end
  end
end
