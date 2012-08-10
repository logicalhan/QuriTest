# note: found these online so didn't write them myself but they look okay to me.
module Enumerable
  def median
    # trivial cases
    return nil if self.empty?

    mid = self.length / 2
    if self.length.odd?
      (entries.sort)[mid]
    else
      s = entries.sort
      (s[mid-1] + s[mid]).to_f / 2.0
    end
  end
end

class Array
  def sum
    inject(0.0) { |result, el| result + el }
  end

  def mean 
    sum / size
  end
end