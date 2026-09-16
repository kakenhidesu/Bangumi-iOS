import SwiftUI
import UIKit

// Backports for APIs introduced after iOS 16. Keep them in one place so they
// can be removed together once the deployment target is raised again.

extension View {
  /// Applies onChange(of:initial:_:) on iOS 17+, falls back to onChange(of:perform:) on earlier versions.
  @ViewBuilder
  func onChangeCompat<V: Equatable>(
    of value: V,
    initial: Bool = false,
    _ action: @escaping (_ oldValue: V, _ newValue: V) -> Void
  ) -> some View {
    if #available(iOS 17.0, *) {
      self.onChange(of: value, initial: initial, action)
    } else {
      self
        .onAppear {
          if initial {
            action(value, value)
          }
        }
        .onChange(of: value) { [value] newValue in
          action(value, newValue)
        }
    }
  }

  /// Applies onChange(of:initial:_:) on iOS 17+, falls back to onChange(of:perform:) on earlier versions.
  @ViewBuilder
  func onChangeCompat<V: Equatable>(
    of value: V,
    initial: Bool = false,
    _ action: @escaping () -> Void
  ) -> some View {
    if #available(iOS 17.0, *) {
      self.onChange(of: value, initial: initial, action)
    } else {
      self
        .onAppear {
          if initial {
            action()
          }
        }
        .onChange(of: value) { _ in
          action()
        }
    }
  }

  /// Applies navigationDestination(item:destination:) on iOS 17+, emulates it with isPresented on earlier versions.
  @ViewBuilder
  func navigationDestinationCompat<D: Hashable, C: View>(
    item: Binding<D?>,
    @ViewBuilder destination: @escaping (D) -> C
  ) -> some View {
    if #available(iOS 17.0, *) {
      self.navigationDestination(item: item, destination: destination)
    } else {
      self.modifier(NavigationDestinationItemModifier(item: item, destination: destination))
    }
  }

  /// Plays selection feedback when trigger changes. Uses sensoryFeedback on iOS 17+.
  @ViewBuilder
  func selectionFeedbackCompat<T: Equatable>(trigger: T) -> some View {
    if #available(iOS 17.0, *) {
      self.sensoryFeedback(.selection, trigger: trigger)
    } else {
      self.onChange(of: trigger) { _ in
        UISelectionFeedbackGenerator().selectionChanged()
      }
    }
  }

  /// Uses a circular button border on iOS 17+, falls back to capsule on earlier versions.
  @ViewBuilder
  func circleButtonBorderShapeCompat() -> some View {
    if #available(iOS 17.0, *) {
      self.buttonBorderShape(.circle)
    } else {
      self.buttonBorderShape(.capsule)
    }
  }

  /// Applies scrollClipDisabled on iOS 17+, returns self on earlier versions.
  @ViewBuilder
  func scrollClipDisabledIfAvailable() -> some View {
    if #available(iOS 17.0, *) {
      self.scrollClipDisabled()
    } else {
      self
    }
  }

  /// Applies scrollTargetLayout on iOS 17+, returns self on earlier versions.
  @ViewBuilder
  func scrollTargetLayoutIfAvailable() -> some View {
    if #available(iOS 17.0, *) {
      self.scrollTargetLayout()
    } else {
      self
    }
  }

  /// Applies view-aligned scrollTargetBehavior on iOS 17+, returns self on earlier versions.
  @ViewBuilder
  func viewAlignedScrollTargetBehaviorIfAvailable() -> some View {
    if #available(iOS 17.0, *) {
      self.scrollTargetBehavior(.viewAligned)
    } else {
      self
    }
  }

  /// Applies geometryGroup on iOS 17+, returns self on earlier versions.
  @ViewBuilder
  func geometryGroupIfAvailable() -> some View {
    if #available(iOS 17.0, *) {
      self.geometryGroup()
    } else {
      self
    }
  }

  /// Applies listSectionSpacing on iOS 17+, returns self on earlier versions.
  @ViewBuilder
  func listSectionSpacingIfAvailable(_ spacing: CGFloat) -> some View {
    if #available(iOS 17.0, *) {
      self.listSectionSpacing(spacing)
    } else {
      self
    }
  }

  /// Applies scroll content margins on iOS 17+, returns self on earlier versions.
  @ViewBuilder
  func scrollContentMarginsIfAvailable(_ edges: Edge.Set, _ length: CGFloat) -> some View {
    if #available(iOS 17.0, *) {
      self.contentMargins(edges, length, for: .scrollContent)
    } else {
      self
    }
  }

  /// Applies bottom safeAreaPadding on iOS 17+, falls back to an empty bottom safe area inset on earlier versions.
  @ViewBuilder
  func bottomSafeAreaPaddingCompat(_ length: CGFloat) -> some View {
    if #available(iOS 17.0, *) {
      self.safeAreaPadding(.bottom, length)
    } else {
      self.safeAreaInset(edge: .bottom, spacing: 0) {
        Color.clear.frame(height: length)
      }
    }
  }

  /// Applies an iterative variable color symbol effect on iOS 17+, returns self on earlier versions.
  @ViewBuilder
  func variableColorSymbolEffectIfAvailable() -> some View {
    if #available(iOS 17.0, *) {
      self.symbolEffect(.variableColor.iterative.dimInactiveLayers)
    } else {
      self
    }
  }

  /// Keeps the toolbar visible while searching on iOS 17.1+, returns self on earlier versions.
  @ViewBuilder
  func searchPresentationToolbarAvoidHidingContentIfAvailable() -> some View {
    if #available(iOS 17.1, *) {
      self.searchPresentationToolbarBehavior(.avoidHidingContent)
    } else {
      self
    }
  }

  /// Applies searchable with a presentation binding on iOS 17+, drops the binding on earlier versions.
  @ViewBuilder
  func searchableCompat(
    text: Binding<String>,
    isPresented: Binding<Bool>,
    placement: SearchFieldPlacement = .automatic,
    prompt: LocalizedStringKey
  ) -> some View {
    if #available(iOS 17.0, *) {
      self.searchable(text: text, isPresented: isPresented, placement: placement, prompt: prompt)
    } else {
      self.searchable(text: text, placement: placement, prompt: prompt)
    }
  }

  /// Applies monospaced on iOS 16.4+, falls back to monospacedDigit on earlier versions.
  @ViewBuilder
  func monospacedCompat() -> some View {
    if #available(iOS 16.4, *) {
      self.monospaced()
    } else {
      self.monospacedDigit()
    }
  }

  /// Keeps a popover as a popover in compact size classes on iOS 16.4+, returns self on earlier versions.
  @ViewBuilder
  func popoverCompactAdaptationIfAvailable() -> some View {
    if #available(iOS 16.4, *) {
      self.presentationCompactAdaptation(.popover)
    } else {
      self
    }
  }

  /// Adapts a popover to a sheet in compact size classes on iOS 16.4+, returns self on earlier versions.
  @ViewBuilder
  func sheetCompactAdaptationIfAvailable() -> some View {
    if #available(iOS 16.4, *) {
      self.presentationCompactAdaptation(.sheet)
    } else {
      self
    }
  }
}

extension Animation {
  /// Uses snappy on iOS 17+, falls back to an equivalent spring on earlier versions.
  static func snappyCompat(duration: TimeInterval = 0.5, extraBounce: Double = 0) -> Animation {
    if #available(iOS 17.0, *) {
      return .snappy(duration: duration, extraBounce: extraBounce)
    }
    return .spring(response: duration, dampingFraction: 0.85 - extraBounce)
  }

  /// Uses smooth on iOS 17+, falls back to an equivalent spring on earlier versions.
  static func smoothCompat(duration: TimeInterval = 0.5, extraBounce: Double = 0) -> Animation {
    if #available(iOS 17.0, *) {
      return .smooth(duration: duration, extraBounce: extraBounce)
    }
    return .spring(response: duration, dampingFraction: 1 - extraBounce)
  }
}

/// Uses ContentUnavailableView on iOS 17+, falls back to a similar stacked layout on earlier versions.
struct ContentUnavailableViewCompat<LabelContent: View, Description: View, Actions: View>: View {
  private let label: LabelContent
  private let description: Description
  private let actions: Actions

  init(
    @ViewBuilder label: () -> LabelContent,
    @ViewBuilder description: () -> Description,
    @ViewBuilder actions: () -> Actions
  ) {
    self.label = label()
    self.description = description()
    self.actions = actions()
  }

  var body: some View {
    if #available(iOS 17.0, *) {
      ContentUnavailableView {
        label
      } description: {
        description
      } actions: {
        actions
      }
    } else {
      VStack(spacing: 8) {
        label
          .labelStyle(ContentUnavailableLabelStyle())
        description
          .font(.callout)
          .foregroundStyle(.secondary)
          .multilineTextAlignment(.center)
        actions
          .padding(.top, 8)
      }
      .padding()
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}

extension ContentUnavailableViewCompat where Actions == EmptyView {
  init(
    @ViewBuilder label: () -> LabelContent,
    @ViewBuilder description: () -> Description
  ) {
    self.init(label: label, description: description, actions: { EmptyView() })
  }
}

extension ContentUnavailableViewCompat
where LabelContent == Label<Text, Image>, Description == EmptyView, Actions == EmptyView {
  init(_ title: LocalizedStringKey, systemImage: String) {
    self.init(
      label: { Label(title, systemImage: systemImage) },
      description: { EmptyView() },
      actions: { EmptyView() }
    )
  }
}

private struct ContentUnavailableLabelStyle: LabelStyle {
  func makeBody(configuration: Configuration) -> some View {
    VStack(spacing: 12) {
      configuration.icon
        .font(.system(size: 48))
        .foregroundStyle(.secondary)
      configuration.title
        .font(.title2.bold())
    }
  }
}

private struct NavigationDestinationItemModifier<D: Hashable, C: View>: ViewModifier {
  @Binding private var item: D?
  private let destination: (D) -> C

  @State private var presentedItem: D?
  @State private var isPresented = false

  init(item: Binding<D?>, destination: @escaping (D) -> C) {
    _item = item
    self.destination = destination
  }

  func body(content: Content) -> some View {
    content
      .navigationDestination(isPresented: $isPresented) {
        if let presentedItem {
          destination(presentedItem)
        }
      }
      .onAppear {
        present(item)
      }
      .onChange(of: item) { newValue in
        present(newValue)
      }
      .onChange(of: isPresented) { newValue in
        if !newValue {
          item = nil
        }
      }
  }

  private func present(_ value: D?) {
    if let value {
      presentedItem = value
      isPresented = true
    } else {
      isPresented = false
    }
  }
}
