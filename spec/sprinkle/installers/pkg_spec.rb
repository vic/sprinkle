require File.dirname(__FILE__) + '/../../spec_helper'

describe Sprinkle::Installers::Pkg do

  before do
    @package = mock(Sprinkle::Package, :name => 'package')
  end

  def create_pkg(pkgs, &block)
    Sprinkle::Installers::Pkg.new(@package, pkgs, &block)
  end

  describe 'when created' do

    it 'should accept a single package to install' do
      @installer = create_pkg 'ruby'
      @installer.packages.should == [ 'ruby' ]
    end

    it 'should accept an array of packages to install' do
      @installer = create_pkg %w( gcc gdb g++ )
      @installer.packages.should == ['gcc', 'gdb', 'g++']
    end

  end

  describe 'during installation' do

    before do
      @installer = create_pkg 'ruby' do
        pre :install, 'op1'
        post :install, 'op2'
      end
      @install_commands = @installer.send :install_commands
    end

    it 'should invoke the pkg installer for all specified packages' do
      @install_commands.should =~ /pkg_add -r ruby/
    end

    it 'should automatically insert pre/post commands for the specified package' do
      @installer.send(:install_sequence).should == [ 'op1', 'pkg_add -r ruby', 'op2' ]
    end

    it 'should install a specific version if defined'

  end

end
