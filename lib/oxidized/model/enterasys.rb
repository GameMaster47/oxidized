class Enterasys < Oxidized::Model
  # Enterasys B3/C3 models #

  prompt /^.+\w\((su|rw)\)->\s?$/

  comment '!'

  # Handle paging
  expect /^--More--.*$/ do |data, re|
    send ' '
    data.sub re, ''
  end

  cmd :all do |cfg|
    cfg.each_line.to_a[2..-3].map { |line| line.delete("\r").rstrip }.join("\n") + "\n"
  end

  cmd 'show system hardware' do |cfg|
    comment cfg
  end

  cmd 'show version' do |cfg|
    comment cfg
  end

  cmd 'show config' do |cfg|
    cfg.gsub! /^This command shows non-default configurations only./, ''
    cfg.gsub! /^Use 'show config all' to show both default and non-default configurations./, ''
    cfg.gsub! /^!|#.*/, ''
    cfg.gsub! /^$\n/, ''

    cfg
  end

  cfg :telnet do
    username /^Username:/i
    password /^Password:/i
  end

  cfg :telnet, :ssh do
    pre_logout 'exit'
  end
end
