class Pilha
  def initialize
    @itens = []
  end

  def empilhar(item)
    @itens.push(item)
  end

  def desempilhar
    if vazia?
      return nil
    else
      return @itens.pop
    end
  end

  def topo
    if vazia?
      return nil
    else
      return @itens[-1]
    end
  end

  def vazia?
    @itens.empty?
  end

  def tamanho
    @itens.size
  end
end
