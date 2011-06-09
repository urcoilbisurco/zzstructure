
class ZigZagStructure
  attr_accessor :n_ranks , :ranks, :nodes
  def initialize
    self.n_ranks=0
    self.ranks=[]
    self.nodes=[]
  end
  
  def view_by_rank(rank)
    chosen_rank=find_rank(rank).to_s
  end
  
  # è il focus del pdf... circa
  def mega_focus(node, rank)
    puts "previous arcs of #{node}"
      mega_focus_in_dietro(node, rank)
    puts "next arcs of #{node}"
      mega_focus_in_avanti(rank.next_node(node), rank)
  end
  
  def mega_focus_in_avanti(node, rank)
    unless node.nil?
      puts "::: The node is: #{node}"
      node.focus
      space
      mega_focus_in_avanti(rank.next_node(node), rank)
    end
  end
  def mega_focus_in_dietro(node, rank)
    unless node.nil?
      puts "::: The node is: #{node}"
      node.focus
      space
      mega_focus_in_dietro(rank.prev_node(node), rank)
    end
  end
  def create_rank(name)
    self.ranks<<Rank.new(name)
    self.ranks.last
  end
  def find_rank(name)
    self.ranks.select {|s| s.name.include? name}.first
  end
  def find_node(node)
    self.nodes.select{|n| n.key.include? node}.first
  end
  def starview
  end
  def to_s
    ranks.each do |r|
      puts r.to_s
      space
    end
  end
  def space
    puts "======================"
  end
 
end

class Node
  attr_accessor :key, :ranks
  def initialize(key, z)
    self.key=key
    self.ranks=[]
    z.nodes<<self
  end
  def create_arc
  end
  def to_s
    key
  end
  #scelgo un nodo, stampo tutti i rank di questo nodo
  def focus
    self.ranks.each do |a|
      puts a.to_s
    end
  end

end
  
class Rank
  attr_accessor :arcs, :name, :headcell, :tailcell
  def initialize(name)
    self.arcs=[]
    self.name=name
    self.headcell=nil
    self.tailcell=nil
  end
  def next_node(node)
    q=self.arcs.select {|s| s.first== node}.first
    q.second unless q.nil?

  end
  def prev_node(node)
    #self.arcs.select{|s| s.second.include? name ? s.first }
     q=self.arcs.select {|s| s.second==node}.first
     q.first unless q.nil?
  end
  def insert(arc)
    #headcell: primo nodo del rank
    #tailcell: ultimo nodo del rank
    self.headcell=arc.first if self.arcs.empty?  
    self.arcs<<arc
    self.tailcell=arc.second
    #inserisco il rank nei nodi dell'arco
    arc.first.ranks=(arc.first.ranks << self).uniq
    arc.second.ranks=(arc.second.ranks << self).uniq
  end
  
  def to_s
    puts "rank name: #{self.name}"
    puts ">>>> headcell: #{headcell}"
    puts ">>>> tailcell: #{tailcell}"
    puts "-ARCS:"
    arcs.each do |a|
      a.to_s
    end
  end

end

class Arc
  attr_accessor :first, :second
  def initialize(node1, node2)
    self.first=node1
    self.second=node2
  end
  def to_s
    "#{self.first.to_s} > > > #{self.second.to_s}"
  end
end




z= ZigZagStructure.new
a=Array.new
(1..13).each do |n|
  a[n]=Node.new "v#{n}", z
end

rank1=z.create_rank("rank1")
rank2=z.create_rank("rank2")
rank3=z.create_rank("rank3")

rank1.insert(Arc.new(a[1],a[5]))
rank1.insert(Arc.new(a[5],a[6]))
rank1.insert(Arc.new(a[6],a[2]))
rank1.insert(Arc.new(a[2],a[3]))
rank1.insert(Arc.new(a[3],a[4]))

rank2.insert(Arc.new(a[9],a[10]))
rank2.insert(Arc.new(a[10],a[11]))
rank2.insert(Arc.new(a[11],a[6]))
rank2.insert(Arc.new(a[6],a[2]))
rank2.insert(Arc.new(a[2],a[3]))
rank2.insert(Arc.new(a[3],a[4]))

rank3.insert(Arc.new(a[4],a[8]))
rank3.insert(Arc.new(a[8],a[13]))
rank3.insert(Arc.new(a[13],a[12]))
rank3.insert(Arc.new(a[12],a[3]))
rank3.insert(Arc.new(a[3],a[1]))

z.mega_focus(z.find_node("v1"), rank1)