class Admin::NodesController < ApplicationController
  layout "admin"
  before_filter :check_admin

  def new
    @node = Node.new
  end

  def create
    @node = @site.build_node(params[:node])
    if @node.save
      redirect_to admin_nodes_path, notice: "Node successfully created!"
    else
      render :new
    end
  end

  def index
    @nodes = @site.node_tree
  end

  def show
    @node = Node.find(params[:id])
  end

  def edit
    @node = Node.find(params[:id])
  end

  def update
    if @node.update_attributes(params[:node])
      redirect_to admin_nodes_path, notice: "Node successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @node = Node.find(params[:id])
    @node.destroy ? flash[:notice] = "Node successfully destroyed!" : admin_request_error("There was an error in deleting the node.")
    redirect_to admin_nodes_path
    
  end

end
