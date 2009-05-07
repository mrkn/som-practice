// -*- mode: c++; coding: utf-8; c-basic-offset: 2; indent-tabs-mode: nil; -*-

#ifndef SOM_HPP_INCLUDED
#define SOM_HPP_INCLUDED 1

#include <cstddef>

#include <boost/random/uniform_real.hpp>

#include <valarray>

class som_1d
{
public:
  typedef std::valarray<double> double_array;

private:
  double const alpha_;
  std::size_t const n_;
  double_array xs_;
  double_array ys_;

public:
  template<class RandomGen>
  som_1d(std::size_t const& n, RandomGen& random)
    : alpha_(0.2),
      n_(n), xs_(n), ys_(n)
    { randomize(random); }

  std::size_t const& n() const { return n_; }
  double_array const& xs() const { return xs_; }
  double_array const& ys() const { return ys_; }

  template<class RandomGen>
  void randomize(RandomGen& random)
    {
      boost::uniform_real<> unif;
      for (std::size_t i = 0; i < n_; ++i) {
        xs_[i] = unif(random);
        ys_[i] = unif(random);
      }
    }

  void activate_at(double x, double y)
    {
      double_array dxs = xs_ - x;
      double_array dys = ys_ - y;
      double_array ds = dxs*dxs + dys*dys;

      std::size_t c = 0;
      for (std::size_t i = 1; i < n_; ++i) if (ds[i] < ds[c]) c = i;

      xs_[c] -= alpha_*dxs[c];
      ys_[c] -= alpha_*dys[c];

      if (c > 0) {
        xs_[c-1] -= 0.5*alpha_*dxs[c-1];
        ys_[c-1] -= 0.5*alpha_*dys[c-1];
      }

      if (c < n_ - 1) {
        xs_[c+1] -= 0.5*alpha_*dxs[c+1];
        ys_[c+1] -= 0.5*alpha_*dys[c+1];
      }
    }
};

#endif // ifndef SOM_HPP_INCLUDED
