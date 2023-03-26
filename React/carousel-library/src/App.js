import Slider from "react-slick";
import "slick-carousel/slick/slick.css";
import "slick-carousel/slick/slick-theme.css";
import styled from "styled-components";

const StyledSlider = styled(Slider)`
  width: 50%;
  height: 50%;
  .slick-prev {
    background: red;
    border: 1px solid black;
    width: 5%;
  }
  .slick-next {
    border: 1px solid black;
    width: 5%;
  }
  .slick-slide {
    margin-left: 1%;
    margin-right: 1%;
  }
`;

function App() {
  const imgList = [
    "https://i.ytimg.com/vi/FQQE3rB8Uc0/maxresdefault.jpg",
    "https://i.ytimg.com/vi/xEut3UavWfk/maxresdefault.jpg",
    "https://i.ytimg.com/vi/xEut3UavWfk/maxresdefault.jpg",
    "https://i.ytimg.com/vi/xEut3UavWfk/maxresdefault.jpg",
    "https://i.ytimg.com/vi/xEut3UavWfk/maxresdefault.jpg",
    "https://i.ytimg.com/vi/xEut3UavWfk/maxresdefault.jpg",
    "https://i.ytimg.com/vi/xEut3UavWfk/maxresdefault.jpg",
    "https://i.ytimg.com/vi/xEut3UavWfk/maxresdefault.jpg",
    "https://i.ytimg.com/vi/xEut3UavWfk/maxresdefault.jpg",
    "https://i.ytimg.com/vi/xEut3UavWfk/maxresdefault.jpg",
    "https://i.ytimg.com/vi/xEut3UavWfk/maxresdefault.jpg",
    "https://i.ytimg.com/vi/xEut3UavWfk/maxresdefault.jpg",
    "https://i.ytimg.com/vi/xEut3UavWfk/maxresdefault.jpg",
    "https://i.ytimg.com/vi/xEut3UavWfk/maxresdefault.jpg",
  ];
  var settings = {
    infinite: true,
    speed: 500,
    slidesToShow: 4,
    slidesToScroll: 4,
    initialSlide: 0,
    responsive: [
      {
        breakpoint: 1024,
        settings: {
          slidesToShow: 3,
          slidesToScroll: 3,
          infinite: true,
        },
      },
      {
        breakpoint: 600,
        settings: {
          slidesToShow: 2,
          slidesToScroll: 2,
          initialSlide: 2,
        },
      },
      {
        breakpoint: 480,
        settings: {
          slidesToShow: 1,
          slidesToScroll: 1,
        },
      },
    ],
  };
  return (
    <div>
      <h2> Responsive </h2>
      <StyledSlider {...settings}>
        {imgList.map((link, idx) => {
          return <img src={link} key={idx}></img>;
        })}
      </StyledSlider>
    </div>
  );
}

export default App;
