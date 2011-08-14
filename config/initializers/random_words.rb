data_root = Rails.root + "lib/data"
NOUNS = File.open(data_root + "nouns.dat"){|f| Marshal.load(f)}
ADJECTIVES = File.open(data_root + "adjs.dat"){|f| Marshal.load(f)}
