//
//  PageViewController.swift
//  UISwift
//
//  Created by zjj on 2020/3/5.
//  Copyright © 2020 zjj. All rights reserved.
//

import SwiftUI
import UIKit

struct PageView<Page: View>: View {
    var viewControllers: [UIHostingController<Page>]
    @State var currentPage = 0
    init(_ views: [Page]) {
        self.viewControllers = views.map { UIHostingController(rootView: $0) }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PageViewController(controllers: viewControllers, currentPage: $currentPage)

            PageControl(numberOfPages: viewControllers.count, currentPage: $currentPage)
                .padding(.trailing)
        }
//        .aspectRatio(1.5, contentMode: .fit)
    }
}

struct PageView_Preview: PreviewProvider {
    static var previews: some View {
        PageView(features.map { FeatureCard(landmark: $0) })
    }
}

struct PageViewController: UIViewControllerRepresentable {
    var controllers: [UIViewController]
    @Binding var currentPage: Int
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator

        return pageViewController
    }

    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers(
            [controllers[currentPage]], direction: .forward, animated: true)
    }

    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController

        init(_ pageViewController: PageViewController) {
            self.parent = pageViewController
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController) -> UIViewController?
        {
            guard let index = parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                return parent.controllers.last
            }
            return parent.controllers[index - 1]
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController) -> UIViewController?
        {
            guard let index = parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == parent.controllers.count {
                return parent.controllers.first
            }
            return parent.controllers[index + 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
                let visibleViewController = pageViewController.viewControllers?.first,
                let index = parent.controllers.firstIndex(of: visibleViewController)
            {
                parent.currentPage = index
            }
        }
    }
}


struct PageControl: UIViewRepresentable {
    var numberOfPages: Int
    @Binding var currentPage: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.addTarget(context.coordinator, action: #selector(Coordinator.updateCurrentPage(sender:)), for: .valueChanged)
        return control
    }

    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }

    class Coordinator: NSObject {
        var control: PageControl

        init(_ control: PageControl) {
            self.control = control
        }

        @objc func updateCurrentPage(sender: UIPageControl) {
            control.currentPage = sender.currentPage
        }
    }
}

struct FeatureCard: View {
    var landmark: Landmark
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            GeometryReader { geo in
                self.landmark.image
                    .resizable().scaledToFill()
            }
            // 用一个GeometryReader就能实现裁剪的image？
            
            VStack(alignment: .leading) {
                Text(landmark.name)
                    .font(.title)
                    .bold()
                Text(landmark.park)
            }.padding()
        }.foregroundColor(.white)
    }
}

struct FeatureCard_Preview: PreviewProvider {
    static var previews: some View {
        FeatureCard(landmark: landmarkData[3])
            .previewLayout(.fixed(width: 300, height: 200))
    }
}
